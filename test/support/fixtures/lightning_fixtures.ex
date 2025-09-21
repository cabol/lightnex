defmodule Lightnex.LightningFixtures do
  @moduledoc false

  alias Lightnex.Conn
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
      identity_pubkey: "02a5c1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
      alias: "alice",
      color: "#33cc99",
      num_pending_channels: 0,
      num_active_channels: 3,
      num_inactive_channels: 1,
      num_peers: 2,
      block_height: 100_000,
      block_hash: "00000000000000000007316856900e76b4f7a9139cfbfba89842c8d196cd5f91",
      best_header_timestamp: DateTime.utc_now() |> DateTime.to_unix(),
      synced_to_chain: true,
      synced_to_graph: true,
      testnet: false,
      chains: [chain()],
      uris: ["02a5c1234567890abcdef@localhost:9735"],
      version: "0.19.3-beta",
      commit_hash: "v0.19.3-beta",
      features: %{},
      require_htlc_interceptor: false,
      store_final_htlc_resolutions: false
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
  Creates a WalletBalanceResponse.
  """
  def wallet_balance_response(opts \\ []) do
    defaults = [
      total_balance: 5_000_000,
      confirmed_balance: 5_000_000,
      unconfirmed_balance: 0,
      locked_balance: 0,
      reserved_balance_anchor_chan: 0,
      account_balance: %{}
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.WalletBalanceResponse, attrs)
  end

  @doc """
  Creates a NewAddressResponse.
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
      peers: [peer()]
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
      value: 1000,
      value_msat: 1_000_000,
      settled: false,
      creation_date: DateTime.utc_now() |> DateTime.to_unix(),
      settle_date: 0,
      payment_request: "lnbcrt10u1p0...",
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
      amp_invoice_state: %{},
      is_blinded: false,
      blinded_path_config: nil
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Invoice, attrs)
  end

  @doc """
  Creates a settled invoice.
  """
  def settled_invoice(opts \\ []) do
    settle_time = DateTime.utc_now() |> DateTime.to_unix()

    defaults = [
      settled: true,
      settle_date: settle_time,
      amt_paid_sat: 1000,
      amt_paid_msat: 1_000_000,
      state: :SETTLED,
      settle_index: 1
    ]

    invoice(Keyword.merge(defaults, opts))
  end

  @doc """
  Creates an AddInvoiceResponse.
  """
  def add_invoice_response(opts \\ []) do
    defaults = [
      r_hash: random_bytes(32),
      payment_request: "lnbcrt10u1p0...",
      add_index: 1,
      payment_addr: random_bytes(32)
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.AddInvoiceResponse, attrs)
  end

  @doc """
  Creates a Payment message.
  """
  def payment(opts \\ []) do
    defaults = [
      payment_hash: payment_hash(),
      value: 0,
      creation_date: 0,
      fee: 0,
      payment_preimage: "",
      value_sat: 1000,
      value_msat: 1_000_000,
      payment_request: "lnbcrt10u1p0...",
      status: :SUCCEEDED,
      fee_sat: 1,
      fee_msat: 1000,
      creation_time_ns: DateTime.utc_now() |> DateTime.to_unix(:nanosecond),
      htlcs: [],
      payment_index: 1,
      failure_reason: :FAILURE_REASON_NONE,
      first_hop_custom_records: %{}
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Payment, attrs)
  end

  @doc """
  Creates a failed payment.
  """
  def failed_payment(opts \\ []) do
    defaults = [
      status: :FAILED,
      failure_reason: :FAILURE_REASON_NO_ROUTE
    ]

    payment(Keyword.merge(defaults, opts))
  end

  @doc """
  Creates an HTLC attempt.
  """
  def htlc_attempt(opts \\ []) do
    defaults = [
      attempt_id: 1,
      status: :SUCCEEDED,
      route: route(),
      attempt_time_ns: DateTime.utc_now() |> DateTime.to_unix(:nanosecond),
      resolve_time_ns: DateTime.utc_now() |> DateTime.to_unix(:nanosecond),
      failure: nil,
      preimage: random_bytes(32)
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.HTLCAttempt, attrs)
  end

  @doc """
  Creates a Route message.
  """
  def route(opts \\ []) do
    defaults = [
      total_time_lock: 640_144,
      total_fees: 0,
      total_amt: 0,
      hops: [hop()],
      total_fees_msat: 1000,
      total_amt_msat: 1_000_000,
      first_hop_amount_msat: 1_001_000,
      custom_channel_data: <<>>
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Route, attrs)
  end

  @doc """
  Creates a Hop message.
  """
  def hop(opts \\ []) do
    defaults = [
      chan_id: 123_456_789_012_345,
      chan_capacity: 0,
      amt_to_forward: 0,
      fee: 0,
      expiry: 640_000,
      amt_to_forward_msat: 1_000_000,
      fee_msat: 1000,
      pub_key: "03b2c2c5c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4",
      tlv_payload: false,
      mpp_record: nil,
      amp_record: nil,
      custom_records: %{},
      metadata: <<>>,
      blinding_point: <<>>,
      encrypted_data: <<>>,
      total_amt_msat: 1_000_000
    ]

    attrs = Keyword.merge(defaults, opts)
    struct(Lightning.Hop, attrs)
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
  Converts a GetInfoResponse to node info map format.
  """
  def response_to_node_info(%Lightning.GetInfoResponse{} = response) do
    %{
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

  defp payment_hash do
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
      info: get_info_response(alias: "alice", color: "#33cc99"),
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
      info: get_info_response(alias: "bob", color: "#3366ff"),
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
