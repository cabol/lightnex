defmodule Lightnex do
  @moduledoc """
  Elixir client for the Lightning Network Daemon (LND).

  Lightnex provides a comprehensive interface to interact with LND nodes via
  gRPC, supporting connection management, peer operations, channel management,
  wallet operations, and more.

  ## Features

  * **Connection Management** - Secure gRPC connections with TLS and macaroon
    authentication.
  * **Peer Management** - Connect, disconnect, and list Lightning Network peers.
  * **Channel Operations** - Open, list, and manage Lightning channels.
  * **Wallet Operations** - Generate addresses, check balances.
  * **Type-safe** - Full typespec coverage with structured responses.
  * **Well-documented** - Comprehensive docs with examples.

  ## Quick Start

      # 1. Connect to LND
      {:ok, conn} = Lightnex.connect("localhost:10009",
        cred: GRPC.Credential.new(ssl: [cacertfile: "~/.lnd/tls.cert"]),
        macaroon: "~/.lnd/data/chain/bitcoin/regtest/admin.macaroon"
      )

      # 2. Get node info
      {:ok, info} = Lightnex.get_info(conn)
      IO.puts("Connected to: \#{info.alias}")

      # 3. Connect to a peer
      {:ok, _} = Lightnex.connect_peer(conn,
        "02abc123...",
        "192.168.1.100:9735"
      )

      # 4. Open a channel
      {:ok, point} = Lightnex.open_channel_sync(conn,
        "02abc123...",
        1_000_000,
        private: true
      )

      # 5. List channels
      {:ok, channels} = Lightnex.list_channels(conn, active_only: true)

  ## Connection Options

  When connecting to an LND node, you can configure:

  * **Authentication** - Macaroon-based auth (file, hex, or binary).
  * **TLS** - Custom certificates and SSL options.
  * **Timeout** - Request timeout configuration.
  * **Validation** - Optional connection validation via `get_info`.

  See `connect/2` for full details.

  ## Error Handling

  All functions return `{:ok, result}` or `{:error, reason}` tuples.
  gRPC errors are returned as `GRPC.RPCError` structs with status codes.
  """

  alias Lightnex.Conn
  alias Lightnex.Conn.NodeInfo
  alias Lightnex.LNRPC.Lightning

  # Default timeout for connections
  @default_timeout :timer.seconds(60)

  ## ===========================================================================
  ## Connection Management
  ## ===========================================================================

  @doc """
  Connects to a LND node with authentication support.

  Establishes a secure gRPC connection to an LND node. By default, the connection
  is validated by calling `get_info/1` to ensure the node is reachable and
  authentication is working.

  ## Options

  #{Conn.conn_opts_docs()}

  ### Additional Options

    * `:validate` - Validate connection with `get_info` (default: `true`)

  > #### Connection options {: .info}
  >
  > `GRPC.Stub.connect/2` options are supported for advanced configuration.

  ## Examples

      # Simple local connection (regtest, no auth)
      {:ok, conn} = Lightnex.connect("localhost:10009")

      # Authenticated connection with macaroon file
      {:ok, conn} = Lightnex.connect("localhost:10009",
        cred: GRPC.Credential.new(ssl: [cacertfile: "~/.lnd/tls.cert"]),
        macaroon: "~/.lnd/data/chain/bitcoin/regtest/admin.macaroon"
      )

      # Connection with hex macaroon
      {:ok, conn} = Lightnex.connect("localhost:10009",
        macaroon: "0201036c6e64...",
        macaroon_type: :hex
      )

      # Skip validation for faster connection
      {:ok, conn} = Lightnex.connect("localhost:10009", validate: false)

  """
  @spec connect(String.t(), keyword()) :: {:ok, Conn.t()} | {:error, any()}
  def connect(address, opts \\ []) when is_binary(address) and is_list(opts) do
    {conn_opts, opts} = Keyword.split(opts, Conn.conn_opts())
    {should_validate?, opts} = Keyword.pop(opts, :validate, true)

    with {:ok, channel} <- GRPC.Stub.connect(address, opts),
         {:ok, conn} <- Conn.new(channel, [address: address] ++ conn_opts) do
      maybe_validate_conn(conn, should_validate?)
    end
  end

  @doc """
  Disconnects from an LND node.

  Closes the gRPC channel to the node. Any subsequent operations on the
  connection will fail.

  ## Examples

      {:ok, conn} = Lightnex.connect("localhost:10009")
      {:ok, channel} = Lightnex.disconnect(conn)

  """
  @spec disconnect(Conn.t()) :: {:ok, GRPC.Channel.t()} | {:error, any()}
  def disconnect(%Conn{channel: channel}) do
    GRPC.Stub.disconnect(channel)
  end

  ## ===========================================================================
  ## Node Information
  ## ===========================================================================

  @doc """
  Gets basic information about the LND node.

  Returns identifying information and current state including:
  * Node identity and alias
  * Connected peers and active channels
  * Blockchain sync status
  * Block height and version

  ## Examples

      {:ok, info} = Lightnex.get_info(conn)
      IO.puts("Node: \#{info.alias}")
      IO.puts("Pubkey: \#{info.identity_pubkey}")
      IO.puts("Block height: \#{info.block_height}")
      IO.puts("Synced to chain: \#{info.synced_to_chain}")
      IO.puts("Active channels: \#{info.num_active_channels}")
      IO.puts("Connected peers: \#{info.num_peers}")

  """
  @spec get_info(Conn.t()) :: {:ok, NodeInfo.t()} | {:error, any()}
  def get_info(%Conn{} = conn) do
    request = %Lightning.GetInfoRequest{}
    metadata = Conn.grpc_metadata(conn)

    with {:ok, response} <- Lightning.Stub.get_info(conn.channel, request, metadata: metadata) do
      info =
        NodeInfo.new(%{
          identity_pubkey: response.identity_pubkey,
          alias: response.alias,
          num_active_channels: response.num_active_channels,
          num_peers: response.num_peers,
          block_height: response.block_height,
          synced_to_chain: response.synced_to_chain,
          synced_to_graph: response.synced_to_graph,
          version: response.version,
          chains: Enum.map(response.chains, &chain_to_map/1)
        })

      {:ok, info}
    end
  end

  ## ===========================================================================
  ## Peer Management
  ## ===========================================================================

  @doc """
  Connects to a Lightning Network peer.

  Establishes a network-level connection to a peer. This does **not** open
  a payment channel - use `open_channel_sync/4` after connecting to open a
  channel.

  The function gracefully handles "already connected" errors by returning
  success.

  ## Parameters

    * `conn` - Active LND connection.
    * `pubkey` - Peer's public key (hex string or binary).
    * `host` - Peer's network address (e.g., "192.168.1.100:9735").
    * `opts` - Optional keyword list.

  ## Options

    * `:perm` - Make this a permanent connection that persists restarts
      (default: `false`).
    * `:timeout` - Connection timeout in milliseconds (default: `60000`).

  ## Examples

      # Connect to peer
      {:ok, _} = Lightnex.connect_peer(conn,
        "02abc123...",
        "192.168.1.100:9735"
      )

      # With permanent connection
      {:ok, _} = Lightnex.connect_peer(conn,
        "02abc123...",
        "192.168.1.100:9735",
        perm: true
      )

      # Already connected returns success
      {:ok, _} = Lightnex.connect_peer(conn, "02abc...", "host:port")
      {:ok, _} = Lightnex.connect_peer(conn, "02abc...", "host:port")  # Still succeeds

  """
  @spec connect_peer(Conn.t(), String.t(), String.t(), keyword()) ::
          {:ok, Lightning.ConnectPeerResponse.t()} | {:error, any()}
  def connect_peer(%Conn{} = conn, pubkey, host, opts \\ [])
      when is_binary(pubkey) and is_binary(host) do
    perm = Keyword.get(opts, :perm, false)
    timeout = Keyword.get(opts, :timeout, @default_timeout)

    # Convert pubkey to hex string if it's binary
    pubkey_hex = format_pubkey(pubkey)

    addr = %Lightning.LightningAddress{
      pubkey: pubkey_hex,
      host: host
    }

    request = %Lightning.ConnectPeerRequest{
      addr: addr,
      perm: perm,
      timeout: timeout
    }

    metadata = Conn.grpc_metadata(conn)

    with {:error, %GRPC.RPCError{message: msg}} = error <-
           Lightning.Stub.connect_peer(conn.channel, request, metadata: metadata) do
      if String.contains?(msg, "already connected") do
        {:ok, %Lightning.ConnectPeerResponse{}}
      else
        error
      end
    end
  end

  @doc """
  Disconnects from a Lightning Network peer.

  Closes the network connection to a peer. This does not close any channels
  with the peer - channels must be closed separately.

  ## Parameters

    * `conn` - Active LND connection.
    * `pubkey` - Peer's public key to disconnect from.

  ## Examples

      {:ok, _} = Lightnex.disconnect_peer(conn, "02abc123...")

  """
  @spec disconnect_peer(Conn.t(), String.t()) ::
          {:ok, Lightning.DisconnectPeerResponse.t()} | {:error, any()}
  def disconnect_peer(%Conn{} = conn, pubkey) when is_binary(pubkey) do
    request = %Lightning.DisconnectPeerRequest{
      pub_key: format_pubkey(pubkey)
    }

    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.disconnect_peer(conn.channel, request, metadata: metadata)
  end

  @doc """
  Lists all currently connected peers.

  Returns information about each connected peer including their pubkey,
  address, bytes sent/received, and error state.

  ## Options

    * `:latest_error` - Include latest errors in response (default: `false`).

  ## Examples

      {:ok, response} = Lightnex.list_peers(conn)
      Enum.each(response.peers, fn peer ->
        IO.puts("Peer: \#{peer.pub_key}@\#{peer.address}")
        IO.puts("  Sent: \#{peer.sat_sent} sats")
        IO.puts("  Received: \#{peer.sat_recv} sats")
      end)

      # Include error information
      {:ok, response} = Lightnex.list_peers(conn, latest_error: true)

  """
  @spec list_peers(Conn.t(), keyword()) ::
          {:ok, Lightning.ListPeersResponse.t()} | {:error, any()}
  def list_peers(%Conn{} = conn, opts \\ []) do
    latest_error = Keyword.get(opts, :latest_error, false)

    request = %Lightning.ListPeersRequest{
      latest_error: latest_error
    }

    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.list_peers(conn.channel, request, metadata: metadata)
  end

  ## ===========================================================================
  ## Channel Management
  ## ===========================================================================

  @doc """
  Opens a Lightning channel synchronously.

  Opens a new payment channel with a peer and waits for the funding transaction
  to be broadcast. This is a blocking operation that returns once the funding
  transaction is confirmed on-chain.

  **Important**: The peer must be connected first via `connect_peer/4`.

  For asynchronous channel opening with progress updates, use the streaming
  `open_channel/4` RPC (not yet implemented).

  ## Parameters

    * `conn` - Active LND connection.
    * `node_pubkey` - Peer's public key (hex string or binary).
    * `local_funding_amount` - Amount in satoshis to fund the channel.
    * `opts` - Optional keyword list for channel parameters.

  ## Options

  ### Basic Options

    * `:push_sat` - Amount to push to remote peer (default: `0`).
    * `:private` - Create private channel not announced to network
      (default: `false`).
    * `:memo` - Channel memo/note (default: `""`).

  ### Fee Options

    * `:target_conf` - Confirmation target in blocks (default: `6`).
    * `:sat_per_vbyte` - Fee rate in sat/vbyte (default: `0`, uses fee estimator).

  ### Channel Parameters

    * `:min_htlc_msat` - Minimum HTLC size in millisatoshis (default: `1000`).
    * `:remote_csv_delay` - Remote CSV delay blocks
      (default: `0`, uses default).
    * `:min_confs` - Minimum confirmations for funding UTXOs (default: `1`).
    * `:spend_unconfirmed` - Allow spending unconfirmed outputs
      (default: `false`).
    * `:close_address` - Address for cooperative close (default: `""`).

  ### Advanced Options

    * `:commitment_type` - Channel commitment type (default: `nil`).
    * `:zero_conf` - Enable zero-conf channel (default: `false`).
    * `:scid_alias` - Enable SCID alias (default: `false`).
    * `:base_fee` - Base forwarding fee in millisatoshis (default: `0`).
    * `:fee_rate` - Fee rate in parts-per-million for forwarding (default: `0`).

  ## Examples

      # Basic channel open (1M sats)
      {:ok, point} = Lightnex.open_channel_sync(conn,
        "02abc123...",
        1_000_000
      )

      # Channel with push amount and custom settings
      {:ok, point} = Lightnex.open_channel_sync(conn,
        "02abc123...",
        5_000_000,
        push_sat: 100_000,
        private: true,
        target_conf: 3,
        memo: "My first channel"
      )

      # Get funding transaction details
      txid = Base.encode16(point.funding_txid_bytes, case: :lower)
      IO.puts("Channel funded: \#{txid}:\#{point.output_index}")

      # Zero-conf private channel with custom routing fees
      {:ok, point} = Lightnex.open_channel_sync(conn,
        "02abc...",
        2_000_000,
        private: true,
        zero_conf: true,
        base_fee: 1000,
        fee_rate: 500
      )

  """
  @spec open_channel_sync(Conn.t(), String.t(), integer(), keyword()) ::
          {:ok, Lightning.ChannelPoint.t()} | {:error, any()}
  def open_channel_sync(%Conn{} = conn, node_pubkey, local_funding_amount, opts \\ [])
      when is_binary(node_pubkey) and is_integer(local_funding_amount) do
    request = build_open_channel_request(node_pubkey, local_funding_amount, opts)
    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.open_channel_sync(conn.channel, request, metadata: metadata)
  end

  @doc """
  Lists all open Lightning channels.

  Returns detailed information about all channels, including balances,
  capacities, peer information, and channel state.

  ## Options

    * `:active_only` - Only return active channels (default: `false`).
    * `:inactive_only` - Only return inactive channels (default: `false`).
    * `:public_only` - Only return public channels (default: `false`).
    * `:private_only` - Only return private channels (default: `false`).
    * `:peer` - Filter by peer pubkey (binary, default: `nil`).
    * `:peer_alias_lookup` - Include peer alias lookup (default: `false`).

  ## Examples

      # List all channels
      {:ok, response} = Lightnex.list_channels(conn)
      Enum.each(response.channels, fn channel ->
        IO.puts("Channel: \#{channel.channel_point}")
        IO.puts("  Capacity: \#{channel.capacity}")
        IO.puts("  Local balance: \#{channel.local_balance}")
        IO.puts("  Remote balance: \#{channel.remote_balance}")
      end)

      # List only active channels
      {:ok, response} = Lightnex.list_channels(conn, active_only: true)

      # Filter by peer
      peer_pubkey = Base.decode16!("02ABC...")
      {:ok, response} = Lightnex.list_channels(conn, peer: peer_pubkey)

      # Only private channels
      {:ok, response} = Lightnex.list_channels(conn, private_only: true)

  """
  @spec list_channels(Conn.t(), keyword()) ::
          {:ok, Lightning.ListChannelsResponse.t()} | {:error, any()}
  def list_channels(%Conn{} = conn, opts \\ []) do
    request = %Lightning.ListChannelsRequest{
      active_only: Keyword.get(opts, :active_only, false),
      inactive_only: Keyword.get(opts, :inactive_only, false),
      public_only: Keyword.get(opts, :public_only, false),
      private_only: Keyword.get(opts, :private_only, false),
      peer: Keyword.get(opts, :peer, <<>>),
      peer_alias_lookup: Keyword.get(opts, :peer_alias_lookup, false)
    }

    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.list_channels(conn.channel, request, metadata: metadata)
  end

  @doc """
  Lists all pending channels.

  Returns channels in various pending states:

  * Pending open - Funding transaction broadcast but not confirmed.
  * Pending close - Cooperative close initiated.
  * Pending force close - Force close initiated.
  * Waiting close - Waiting for close transaction confirmation.

  ## Examples

      {:ok, response} = Lightnex.pending_channels(conn)
      IO.puts("Pending open: \#{length(response.pending_open_channels)}")
      IO.puts("Pending close: \#{length(response.pending_closing_channels)}")
      IO.puts("Pending force close: \#{length(response.pending_force_closing_channels)}")
      IO.puts("Waiting close: \#{length(response.waiting_close_channels)}")

  """
  @spec pending_channels(Conn.t()) ::
          {:ok, Lightning.PendingChannelsResponse.t()} | {:error, any()}
  def pending_channels(%Conn{} = conn) do
    request = %Lightning.PendingChannelsRequest{}
    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.pending_channels(conn.channel, request, metadata: metadata)
  end

  @doc """
  Lists all closed channels.

  Returns information about channels that have been closed, including
  the close type, closing transaction, and final balances.

  ## Options

    * `:cooperative` - Only cooperative closes (default: `false`).
    * `:local_force` - Only local force closes (default: `false`).
    * `:remote_force` - Only remote force closes (default: `false`).
    * `:breach` - Only breach closes (default: `false`).
    * `:funding_canceled` - Only funding canceled (default: `false`).
    * `:abandoned` - Only abandoned channels (default: `false`).

  ## Examples

      # All closed channels
      {:ok, response} = Lightnex.closed_channels(conn)

      # Only cooperative closes
      {:ok, response} = Lightnex.closed_channels(conn, cooperative: true)

      # Only force closes
      {:ok, response} = Lightnex.closed_channels(conn,
        local_force: true,
        remote_force: true
      )

  """
  @spec closed_channels(Conn.t(), keyword()) ::
          {:ok, Lightning.ClosedChannelsResponse.t()} | {:error, any()}
  def closed_channels(%Conn{} = conn, opts \\ []) do
    request = %Lightning.ClosedChannelsRequest{
      cooperative: Keyword.get(opts, :cooperative, false),
      local_force: Keyword.get(opts, :local_force, false),
      remote_force: Keyword.get(opts, :remote_force, false),
      breach: Keyword.get(opts, :breach, false),
      abandoned: Keyword.get(opts, :abandoned, false),
      funding_canceled: Keyword.get(opts, :funding_canceled, false)
    }

    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.closed_channels(conn.channel, request, metadata: metadata)
  end

  @doc """
  Closes a Lightning channel cooperatively.

  Initiates a cooperative close of a channel with the specified peer.
  This is a streaming RPC that returns close status updates.

  ## Parameters

    * `conn` - Active LND connection.
    * `channel_point` - Channel point identifying the channel to close.
    * `opts` - Optional keyword list for close parameters.

  ## Options

    * `:force` - Force close the channel (default: `false`).
    * `:target_conf` - Confirmation target in blocks (default: `0`).
    * `:sat_per_vbyte` - Fee rate in sat/vbyte (default: `0`).
    * `:delivery_address` - Address to send funds (default: `""`).

  ## Examples

      # Cooperative close
      {:ok, stream} = Lightnex.close_channel(conn, channel_point)

      # Force close with custom fee
      {:ok, stream} = Lightnex.close_channel(conn, channel_point,
        force: true,
        sat_per_vbyte: 10
      )

  """
  @spec close_channel(Conn.t(), Lightning.ChannelPoint.t(), keyword()) ::
          {:ok, Enumerable.t()} | {:error, any()}
  def close_channel(%Conn{} = conn, %Lightning.ChannelPoint{} = channel_point, opts \\ []) do
    request = %Lightning.CloseChannelRequest{
      channel_point: channel_point,
      force: Keyword.get(opts, :force, false),
      target_conf: Keyword.get(opts, :target_conf, 0),
      sat_per_vbyte: Keyword.get(opts, :sat_per_vbyte, 0),
      delivery_address: Keyword.get(opts, :delivery_address, "")
    }

    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.close_channel(conn.channel, request, metadata: metadata)
  end

  ## ===========================================================================
  ## Wallet Management
  ## ===========================================================================

  @doc """
  Generates a new on-chain Bitcoin address.

  Creates a new address in the LND wallet for receiving on-chain funds.

  ## Options

    * `:type` - Address type (default: `:WITNESS_PUBKEY_HASH`).
      - `:WITNESS_PUBKEY_HASH` - Native SegWit (bech32).
      - `:NESTED_PUBKEY_HASH` - Nested SegWit (P2SH).
      - `:UNUSED_WITNESS_PUBKEY_HASH` - Unused native SegWit.
      - `:UNUSED_NESTED_PUBKEY_HASH` - Unused nested SegWit.
      - `:TAPROOT_PUBKEY` - Taproot (bech32m).
    * `:account` - Wallet account name (default: `"default"`).

  ## Examples

      # Generate default address (native SegWit)
      {:ok, response} = Lightnex.new_address(conn)
      IO.puts("Address: \#{response.address}")

      # Generate Taproot address
      {:ok, response} = Lightnex.new_address(conn, type: :TAPROOT_PUBKEY)

      # Use specific account
      {:ok, response} = Lightnex.new_address(conn, account: "savings")

  """
  @spec new_address(Conn.t(), keyword()) ::
          {:ok, Lightning.NewAddressResponse.t()} | {:error, any()}
  def new_address(%Conn{} = conn, opts \\ []) do
    address_type = Keyword.get(opts, :type, :WITNESS_PUBKEY_HASH)
    account = Keyword.get(opts, :account, "default")

    request = %Lightning.NewAddressRequest{
      type: address_type,
      account: account
    }

    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.new_address(conn.channel, request, metadata: metadata)
  end

  @doc """
  Gets the on-chain wallet balance.

  Returns the confirmed and unconfirmed balance of the wallet,
  plus any locked balance in pending channels.

  ## Examples

      {:ok, response} = Lightnex.wallet_balance(conn)
      IO.puts("Confirmed: \#{response.confirmed_balance} sats")
      IO.puts("Unconfirmed: \#{response.unconfirmed_balance} sats")
      IO.puts("Total: \#{response.total_balance} sats")

  """
  @spec wallet_balance(Conn.t()) ::
          {:ok, Lightning.WalletBalanceResponse.t()} | {:error, any()}
  def wallet_balance(%Conn{} = conn) do
    request = %Lightning.WalletBalanceRequest{}
    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.wallet_balance(conn.channel, request, metadata: metadata)
  end

  @doc """
  Gets the Lightning channel balance.

  Returns the total balance across all Lightning channels,
  including pending open balances.

  ## Examples

      {:ok, response} = Lightnex.channel_balance(conn)
      IO.puts("Balance: \#{response.balance} sats")
      IO.puts("Pending open: \#{response.pending_open_balance} sats")

  """
  @spec channel_balance(Conn.t()) ::
          {:ok, Lightning.ChannelBalanceResponse.t()} | {:error, any()}
  def channel_balance(%Conn{} = conn) do
    request = %Lightning.ChannelBalanceRequest{}
    metadata = Conn.grpc_metadata(conn)

    Lightning.Stub.channel_balance(conn.channel, request, metadata: metadata)
  end

  ## ===========================================================================
  ## Private Helpers
  ## ===========================================================================

  defp maybe_validate_conn(conn, false) do
    {:ok, conn}
  end

  defp maybe_validate_conn(conn, true) do
    with {:ok, info} <- get_info(conn) do
      {:ok, Conn.put_node_info(conn, info)}
    end
  end

  defp chain_to_map(chain) do
    %{
      chain: chain.chain,
      network: chain.network
    }
  end

  defp normalize_pubkey(pubkey) when is_binary(pubkey) do
    # If it looks like hex, decode it
    if String.match?(pubkey, ~r/^[0-9a-fA-F]+$/) and String.length(pubkey) == 66 do
      # We already validated it's valid hex, so decode will always succeed
      Base.decode16!(pubkey, case: :mixed)
    else
      pubkey
    end
  end

  defp format_pubkey(pubkey) when is_binary(pubkey) do
    # Check if it's already a hex string (only contains hex characters)
    if String.match?(pubkey, ~r/^[0-9a-fA-F]+$/) do
      pubkey
    else
      # It's binary data, convert to hex
      Base.encode16(pubkey, case: :lower)
    end
  end

  defp build_open_channel_request(node_pubkey, local_funding_amount, opts) do
    %Lightning.OpenChannelRequest{
      node_pubkey: normalize_pubkey(node_pubkey),
      local_funding_amount: local_funding_amount,
      push_sat: Keyword.get(opts, :push_sat, 0),
      target_conf: Keyword.get(opts, :target_conf, 6),
      sat_per_vbyte: Keyword.get(opts, :sat_per_vbyte, 0),
      private: Keyword.get(opts, :private, false),
      min_htlc_msat: Keyword.get(opts, :min_htlc_msat, 1000),
      remote_csv_delay: Keyword.get(opts, :remote_csv_delay, 0),
      min_confs: Keyword.get(opts, :min_confs, 1),
      spend_unconfirmed: Keyword.get(opts, :spend_unconfirmed, false),
      close_address: Keyword.get(opts, :close_address, ""),
      commitment_type: Keyword.get(opts, :commitment_type),
      zero_conf: Keyword.get(opts, :zero_conf, false),
      scid_alias: Keyword.get(opts, :scid_alias, false),
      base_fee: Keyword.get(opts, :base_fee, 0),
      fee_rate: Keyword.get(opts, :fee_rate, 0),
      use_base_fee: Keyword.has_key?(opts, :base_fee),
      use_fee_rate: Keyword.has_key?(opts, :fee_rate),
      memo: Keyword.get(opts, :memo, "")
    }
  end
end
