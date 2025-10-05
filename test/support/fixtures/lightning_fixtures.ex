defmodule Lightnex.LightningFixtures do
  @moduledoc false

  alias Lightnex.Conn
  alias Lightnex.Conn.NodeInfo
  alias Lightnex.LNRPC.Lightning

  @port 10_009

  @doc """
  Creates a mock GRPC channel.
  """
  def grpc_channel(opts \\ []) do
    defaults = [host: "localhost", port: @port, scheme: :http]
    attrs = Keyword.merge(defaults, opts)

    struct(GRPC.Channel, attrs)
  end

  @doc """
  Creates a Lightnex connection with default or custom attributes.
  """
  def connection(opts \\ []) do
    defaults = [
      channel: grpc_channel(),
      macaroon_hex: nil,
      timeout: 30_000,
      address: "localhost:#{@port}",
      node_info: nil,
      connected_at: DateTime.utc_now()
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Conn, attrs)
  end

  @doc """
  Creates an authenticated connection with a macaroon.
  """
  def authenticated_connection(opts \\ []) do
    defaults = [macaroon_hex: valid_macaroon_hex()]
    connection(Keyword.merge(defaults, opts))
  end

  @doc """
  Creates a connection with node info populated.
  """
  def connection_with_node_info(opts \\ []) do
    node_info = get_info_response() |> response_to_node_info()
    defaults = [node_info: node_info]
    connection(Keyword.merge(defaults, opts))
  end

  @doc """
  Generates a valid hex-encoded macaroon.
  """
  def valid_macaroon_hex do
    "0201036c6e640247030a20a5c1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1a160a0761646472657373120472656164120577726974651a170a08696e766f69636573120472656164120577726974651a210a086d616361726f6f6e120867656e6572617465120472656164120577726974651a160a076d657373616765120472656164120577726974651a170a086f6666636861696e120472656164120577726974651a160a076f6e636861696e120472656164120577726974651a14a00a0870656572731204726561641205777269746500000620a5c1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
  end

  @doc """
  Generates an invalid hex macaroon for error testing.
  """
  def invalid_macaroon_hex do
    "invalid_hex_string"
  end

  @doc """
  Generates a binary macaroon.
  """
  def binary_macaroon do
    Base.decode16!(valid_macaroon_hex(), case: :lower)
  end

  @doc """
  Creates a GetInfoResponse with default or custom attributes.
  """
  def get_info_response(opts \\ []) do
    defaults = [
      identity_pubkey: "03b2c2c5c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4",
      alias: "test-node",
      num_active_channels: 5,
      num_peers: 3,
      block_height: 100_000,
      synced_to_chain: true,
      synced_to_graph: true,
      version: "0.18.0-beta",
      chains: [chain()]
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.GetInfoResponse, attrs)
  end

  @doc """
  Creates a Chain message.
  """
  def chain(opts \\ []) do
    defaults = [
      chain: "bitcoin",
      network: "regtest"
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Chain, attrs)
  end

  @doc """
  Creates a NodeInfo struct from a GetInfoResponse.
  """
  def node_info(opts \\ []) do
    response = get_info_response(opts)
    response_to_node_info(response)
  end

  @doc """
  Creates a NewAddressResponse message.
  """
  def new_address_response(opts \\ []) do
    defaults = [
      address: "bcrt1qw508d6qejxtdg4y5r3zarvary0c5xw7kygt080"
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.NewAddressResponse, attrs)
  end

  @doc """
  Creates a Channel message.
  """
  def channel(opts \\ []) do
    defaults = [
      active: true,
      remote_pubkey: "03b2c2c5c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4",
      channel_point: "#{transaction_hash()}:0",
      chan_id: 123_456_789_012_345,
      capacity: 1_000_000,
      local_balance: 500_000,
      remote_balance: 500_000,
      commit_fee: 5000,
      commit_weight: 724,
      fee_per_kw: 2500,
      unsettled_balance: 0,
      total_satoshis_sent: 100_000,
      total_satoshis_received: 50_000,
      num_updates: 10,
      pending_htlcs: [],
      csv_delay: 144,
      private: false,
      initiator: true,
      chan_status_flags: "",
      local_chan_reserve_sat: 10_000,
      remote_chan_reserve_sat: 10_000,
      static_remote_key: false,
      commitment_type: :STATIC_REMOTE_KEY,
      lifetime: 86_400,
      uptime: 85_000,
      close_address: "",
      push_amount_sat: 0,
      thaw_height: 0,
      local_constraints: channel_constraints(),
      remote_constraints: channel_constraints(),
      alias_scids: [],
      zero_conf: false,
      zero_conf_confirmed_scid: 0,
      peer_alias: "bob",
      peer_scid_alias: 0,
      memo: "",
      custom_channel_data: <<>>
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Channel, attrs)
  end

  @doc """
  Creates ChannelConstraints.
  """
  def channel_constraints(opts \\ []) do
    defaults = [
      csv_delay: 144,
      chan_reserve_sat: 10_000,
      dust_limit_sat: 546,
      max_pending_amt_msat: 990_000_000,
      min_htlc_msat: 1000,
      max_accepted_htlcs: 483
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.ChannelConstraints, attrs)
  end

  @doc """
  Creates a ListChannelsResponse.
  """
  def list_channels_response(opts \\ []) do
    defaults = [
      channels: [
        channel(),
        channel(
          remote_pubkey: "03c2c2c5c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4"
        )
      ]
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.ListChannelsResponse, attrs)
  end

  @doc """
  Creates a Peer message.
  """
  def peer(opts \\ []) do
    defaults = [
      pub_key: "03b2c2c5c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4",
      address: "192.168.1.100:9735",
      bytes_sent: 1024,
      bytes_recv: 2048,
      sat_sent: 100_000,
      sat_recv: 50_000,
      inbound: false,
      ping_time: 150_000,
      sync_type: :ACTIVE_SYNC,
      features: %{},
      errors: [],
      flap_count: 0,
      last_flap_ns: 0,
      last_ping_payload: <<>>
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Peer, attrs)
  end

  @doc """
  Creates a ListPeersResponse.
  """
  def list_peers_response(opts \\ []) do
    defaults = [
      peers: [
        peer(),
        peer(pub_key: "03c2c2c5c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4")
      ]
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.ListPeersResponse, attrs)
  end

  @doc """
  Creates an Invoice message.
  """
  def invoice(opts \\ []) do
    defaults = [
      memo: "Test invoice",
      r_preimage: random_bytes(32),
      r_hash: random_bytes(32),
      value: 10_000,
      value_msat: 10_000_000,
      settled: false,
      creation_date: DateTime.utc_now() |> DateTime.to_unix(),
      settle_date: 0,
      payment_request: "lnbc100n1...",
      description_hash: <<>>,
      expiry: 3600,
      fallback_addr: "",
      cltv_expiry: 40,
      route_hints: [],
      private: false,
      add_index: 1,
      settle_index: 0,
      amt_paid: 0,
      amt_paid_sat: 0,
      amt_paid_msat: 0,
      state: :OPEN,
      htlcs: [],
      features: %{},
      is_keysend: false,
      payment_addr: random_bytes(32),
      is_amp: false,
      amp_invoice_state: %{}
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Invoice, attrs)
  end

  @doc """
  Creates a settled Invoice.
  """
  def settled_invoice(opts \\ []) do
    defaults = [
      settled: true,
      settle_date: DateTime.utc_now() |> DateTime.to_unix(),
      state: :SETTLED,
      amt_paid_sat: 10_000
    ]

    invoice(Keyword.merge(defaults, opts))
  end

  @doc """
  Creates a Transaction message.
  """
  def transaction(opts \\ []) do
    defaults = [
      tx_hash: transaction_hash(),
      amount: 1_000_000,
      num_confirmations: 6,
      block_hash: "00000000000000000007316856900e76b4f7a9139cfbfba89842c8d196cd5f91",
      block_height: 100_000,
      time_stamp: DateTime.utc_now() |> DateTime.to_unix(),
      total_fees: 1000,
      dest_addresses: [],
      output_details: [],
      raw_tx_hex: "0200000001...",
      label: "Test transaction",
      previous_outpoints: []
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Transaction, attrs)
  end

  @doc """
  Creates gRPC error responses for testing error scenarios.
  """
  def grpc_error(type \\ :unavailable) do
    case type do
      :unavailable ->
        {:error, %GRPC.RPCError{status: 14, message: "unavailable"}}

      :permission_denied ->
        {:error, %GRPC.RPCError{status: 7, message: "permission denied"}}

      :not_found ->
        {:error, %GRPC.RPCError{status: 5, message: "not found"}}

      :invalid_argument ->
        {:error, %GRPC.RPCError{status: 3, message: "invalid argument"}}

      :unauthenticated ->
        {:error, %GRPC.RPCError{status: 16, message: "unauthenticated"}}

      _ ->
        {:error, %GRPC.RPCError{status: 2, message: "unknown"}}
    end
  end

  # Private helper functions

  @doc """
  Converts a GetInfoResponse to NodeInfo struct.

  This is the key function that needs to create NodeInfo structs instead of maps.
  """
  def response_to_node_info(%Lightning.GetInfoResponse{} = response) do
    %NodeInfo{
      identity_pubkey: response.identity_pubkey,
      alias: response.alias,
      num_active_channels: response.num_active_channels,
      num_peers: response.num_peers,
      block_height: response.block_height,
      synced_to_chain: response.synced_to_chain,
      synced_to_graph: response.synced_to_graph,
      version: response.version,
      chains:
        Enum.map(response.chains, fn chain ->
          %{chain: chain.chain, network: chain.network}
        end)
    }
  end

  defp random_bytes(length) do
    :crypto.strong_rand_bytes(length)
  end

  defp transaction_hash do
    random_bytes(32) |> Base.encode16(case: :lower)
  end

  @doc """
  Creates test scenarios with multiple related objects.
  """
  def alice_scenario do
    %{
      connection:
        connection_with_node_info(
          address: "localhost:10019",
          macaroon_hex: valid_macaroon_hex()
        ),
      info: node_info(alias: "alice", color: "#33cc99"),
      channels: [
        channel(peer_alias: "bob", active: true),
        channel(peer_alias: "charlie", active: false)
      ],
      peers: [
        peer(pub_key: "03b2c2c5...")
      ],
      invoices: [
        invoice(memo: "Alice test invoice"),
        settled_invoice(memo: "Settled invoice")
      ]
    }
  end

  @doc """
  Creates Bob scenario for multi-node testing.
  """
  def bob_scenario do
    %{
      connection:
        connection_with_node_info(
          address: "localhost:10029",
          macaroon_hex: valid_macaroon_hex()
        ),
      info: node_info(alias: "bob", color: "#3366ff"),
      channels: [
        channel(peer_alias: "alice", active: true)
      ],
      peers: [
        peer(pub_key: "02a5c1234...")
      ]
    }
  end

  @doc """
  Creates error scenarios for testing error handling.
  """
  def error_scenarios do
    %{
      connection_refused: grpc_error(:unavailable),
      permission_denied: grpc_error(:permission_denied),
      invalid_macaroon: grpc_error(:unauthenticated),
      not_found: grpc_error(:not_found)
    }
  end
end
