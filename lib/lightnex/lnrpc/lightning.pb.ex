defmodule Lightnex.LNRPC.Lightning.OutputScriptType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :SCRIPT_TYPE_PUBKEY_HASH, 0
  field :SCRIPT_TYPE_SCRIPT_HASH, 1
  field :SCRIPT_TYPE_WITNESS_V0_PUBKEY_HASH, 2
  field :SCRIPT_TYPE_WITNESS_V0_SCRIPT_HASH, 3
  field :SCRIPT_TYPE_PUBKEY, 4
  field :SCRIPT_TYPE_MULTISIG, 5
  field :SCRIPT_TYPE_NULLDATA, 6
  field :SCRIPT_TYPE_NON_STANDARD, 7
  field :SCRIPT_TYPE_WITNESS_UNKNOWN, 8
  field :SCRIPT_TYPE_WITNESS_V1_TAPROOT, 9
end

defmodule Lightnex.LNRPC.Lightning.CoinSelectionStrategy do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :STRATEGY_USE_GLOBAL_CONFIG, 0
  field :STRATEGY_LARGEST, 1
  field :STRATEGY_RANDOM, 2
end

defmodule Lightnex.LNRPC.Lightning.AddressType do
  @moduledoc """
  `AddressType` has to be one of:

  - `p2wkh`: Pay to witness key hash (`WITNESS_PUBKEY_HASH` = 0)
  - `np2wkh`: Pay to nested witness key hash (`NESTED_PUBKEY_HASH` = 1)
  - `p2tr`: Pay to taproot pubkey (`TAPROOT_PUBKEY` = 4)
  """

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :WITNESS_PUBKEY_HASH, 0
  field :NESTED_PUBKEY_HASH, 1
  field :UNUSED_WITNESS_PUBKEY_HASH, 2
  field :UNUSED_NESTED_PUBKEY_HASH, 3
  field :TAPROOT_PUBKEY, 4
  field :UNUSED_TAPROOT_PUBKEY, 5
end

defmodule Lightnex.LNRPC.Lightning.CommitmentType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN_COMMITMENT_TYPE, 0
  field :LEGACY, 1
  field :STATIC_REMOTE_KEY, 2
  field :ANCHORS, 3
  field :SCRIPT_ENFORCED_LEASE, 4
  field :SIMPLE_TAPROOT, 5
  field :SIMPLE_TAPROOT_OVERLAY, 6
end

defmodule Lightnex.LNRPC.Lightning.Initiator do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :INITIATOR_UNKNOWN, 0
  field :INITIATOR_LOCAL, 1
  field :INITIATOR_REMOTE, 2
  field :INITIATOR_BOTH, 3
end

defmodule Lightnex.LNRPC.Lightning.ResolutionType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :TYPE_UNKNOWN, 0
  field :ANCHOR, 1
  field :INCOMING_HTLC, 2
  field :OUTGOING_HTLC, 3
  field :COMMIT, 4
end

defmodule Lightnex.LNRPC.Lightning.ResolutionOutcome do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :OUTCOME_UNKNOWN, 0
  field :CLAIMED, 1
  field :UNCLAIMED, 2
  field :ABANDONED, 3
  field :FIRST_STAGE, 4
  field :TIMEOUT, 5
end

defmodule Lightnex.LNRPC.Lightning.NodeMetricType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN, 0
  field :BETWEENNESS_CENTRALITY, 1
end

defmodule Lightnex.LNRPC.Lightning.InvoiceHTLCState do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :ACCEPTED, 0
  field :SETTLED, 1
  field :CANCELED, 2
end

defmodule Lightnex.LNRPC.Lightning.PaymentFailureReason do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :FAILURE_REASON_NONE, 0
  field :FAILURE_REASON_TIMEOUT, 1
  field :FAILURE_REASON_NO_ROUTE, 2
  field :FAILURE_REASON_ERROR, 3
  field :FAILURE_REASON_INCORRECT_PAYMENT_DETAILS, 4
  field :FAILURE_REASON_INSUFFICIENT_BALANCE, 5
  field :FAILURE_REASON_CANCELED, 6
end

defmodule Lightnex.LNRPC.Lightning.FeatureBit do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :DATALOSS_PROTECT_REQ, 0
  field :DATALOSS_PROTECT_OPT, 1
  field :INITIAL_ROUING_SYNC, 3
  field :UPFRONT_SHUTDOWN_SCRIPT_REQ, 4
  field :UPFRONT_SHUTDOWN_SCRIPT_OPT, 5
  field :GOSSIP_QUERIES_REQ, 6
  field :GOSSIP_QUERIES_OPT, 7
  field :TLV_ONION_REQ, 8
  field :TLV_ONION_OPT, 9
  field :EXT_GOSSIP_QUERIES_REQ, 10
  field :EXT_GOSSIP_QUERIES_OPT, 11
  field :STATIC_REMOTE_KEY_REQ, 12
  field :STATIC_REMOTE_KEY_OPT, 13
  field :PAYMENT_ADDR_REQ, 14
  field :PAYMENT_ADDR_OPT, 15
  field :MPP_REQ, 16
  field :MPP_OPT, 17
  field :WUMBO_CHANNELS_REQ, 18
  field :WUMBO_CHANNELS_OPT, 19
  field :ANCHORS_REQ, 20
  field :ANCHORS_OPT, 21
  field :ANCHORS_ZERO_FEE_HTLC_REQ, 22
  field :ANCHORS_ZERO_FEE_HTLC_OPT, 23
  field :ROUTE_BLINDING_REQUIRED, 24
  field :ROUTE_BLINDING_OPTIONAL, 25
  field :AMP_REQ, 30
  field :AMP_OPT, 31
end

defmodule Lightnex.LNRPC.Lightning.UpdateFailure do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UPDATE_FAILURE_UNKNOWN, 0
  field :UPDATE_FAILURE_PENDING, 1
  field :UPDATE_FAILURE_NOT_FOUND, 2
  field :UPDATE_FAILURE_INTERNAL_ERR, 3
  field :UPDATE_FAILURE_INVALID_PARAMETER, 4
end

defmodule Lightnex.LNRPC.Lightning.ChannelCloseSummary.ClosureType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :COOPERATIVE_CLOSE, 0
  field :LOCAL_FORCE_CLOSE, 1
  field :REMOTE_FORCE_CLOSE, 2
  field :BREACH_CLOSE, 3
  field :FUNDING_CANCELED, 4
  field :ABANDONED, 5
end

defmodule Lightnex.LNRPC.Lightning.Peer.SyncType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN_SYNC, 0
  field :ACTIVE_SYNC, 1
  field :PASSIVE_SYNC, 2
  field :PINNED_SYNC, 3
end

defmodule Lightnex.LNRPC.Lightning.PeerEvent.EventType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :PEER_ONLINE, 0
  field :PEER_OFFLINE, 1
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse.ForceClosedChannel.AnchorState do
  @moduledoc """
  There are three resolution states for the anchor:
  limbo, lost and recovered. Derive the current state
  from the limbo and recovered balances.
  """

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :LIMBO, 0
  field :RECOVERED, 1
  field :LOST, 2
end

defmodule Lightnex.LNRPC.Lightning.ChannelEventUpdate.UpdateType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :OPEN_CHANNEL, 0
  field :CLOSED_CHANNEL, 1
  field :ACTIVE_CHANNEL, 2
  field :INACTIVE_CHANNEL, 3
  field :PENDING_OPEN_CHANNEL, 4
  field :FULLY_RESOLVED_CHANNEL, 5
  field :CHANNEL_FUNDING_TIMEOUT, 6
end

defmodule Lightnex.LNRPC.Lightning.Invoice.InvoiceState do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :OPEN, 0
  field :SETTLED, 1
  field :CANCELED, 2
  field :ACCEPTED, 3
end

defmodule Lightnex.LNRPC.Lightning.Payment.PaymentStatus do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN, 0
  field :IN_FLIGHT, 1
  field :SUCCEEDED, 2
  field :FAILED, 3
  field :INITIATED, 4
end

defmodule Lightnex.LNRPC.Lightning.HTLCAttempt.HTLCStatus do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :IN_FLIGHT, 0
  field :SUCCEEDED, 1
  field :FAILED, 2
end

defmodule Lightnex.LNRPC.Lightning.Failure.FailureCode do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :RESERVED, 0
  field :INCORRECT_OR_UNKNOWN_PAYMENT_DETAILS, 1
  field :INCORRECT_PAYMENT_AMOUNT, 2
  field :FINAL_INCORRECT_CLTV_EXPIRY, 3
  field :FINAL_INCORRECT_HTLC_AMOUNT, 4
  field :FINAL_EXPIRY_TOO_SOON, 5
  field :INVALID_REALM, 6
  field :EXPIRY_TOO_SOON, 7
  field :INVALID_ONION_VERSION, 8
  field :INVALID_ONION_HMAC, 9
  field :INVALID_ONION_KEY, 10
  field :AMOUNT_BELOW_MINIMUM, 11
  field :FEE_INSUFFICIENT, 12
  field :INCORRECT_CLTV_EXPIRY, 13
  field :CHANNEL_DISABLED, 14
  field :TEMPORARY_CHANNEL_FAILURE, 15
  field :REQUIRED_NODE_FEATURE_MISSING, 16
  field :REQUIRED_CHANNEL_FEATURE_MISSING, 17
  field :UNKNOWN_NEXT_PEER, 18
  field :TEMPORARY_NODE_FAILURE, 19
  field :PERMANENT_NODE_FAILURE, 20
  field :PERMANENT_CHANNEL_FAILURE, 21
  field :EXPIRY_TOO_FAR, 22
  field :MPP_TIMEOUT, 23
  field :INVALID_ONION_PAYLOAD, 24
  field :INVALID_ONION_BLINDING, 25
  field :INTERNAL_FAILURE, 997
  field :UNKNOWN_FAILURE, 998
  field :UNREADABLE_FAILURE, 999
end

defmodule Lightnex.LNRPC.Lightning.LookupHtlcResolutionRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId"
  field :htlc_index, 2, type: :uint64, json_name: "htlcIndex"
end

defmodule Lightnex.LNRPC.Lightning.LookupHtlcResolutionResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :settled, 1, type: :bool
  field :offchain, 2, type: :bool
end

defmodule Lightnex.LNRPC.Lightning.SubscribeCustomMessagesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.CustomMessage do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :peer, 1, type: :bytes
  field :type, 2, type: :uint32
  field :data, 3, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.SendCustomMessageRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :peer, 1, type: :bytes
  field :type, 2, type: :uint32
  field :data, 3, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.SendCustomMessageResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.Utxo do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :address_type, 1,
    type: Lightnex.LNRPC.Lightning.AddressType,
    json_name: "addressType",
    enum: true

  field :address, 2, type: :string
  field :amount_sat, 3, type: :int64, json_name: "amountSat"
  field :pk_script, 4, type: :string, json_name: "pkScript"
  field :outpoint, 5, type: Lightnex.LNRPC.Lightning.OutPoint
  field :confirmations, 6, type: :int64
end

defmodule Lightnex.LNRPC.Lightning.OutputDetail do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :output_type, 1,
    type: Lightnex.LNRPC.Lightning.OutputScriptType,
    json_name: "outputType",
    enum: true

  field :address, 2, type: :string
  field :pk_script, 3, type: :string, json_name: "pkScript"
  field :output_index, 4, type: :int64, json_name: "outputIndex"
  field :amount, 5, type: :int64
  field :is_our_address, 6, type: :bool, json_name: "isOurAddress"
end

defmodule Lightnex.LNRPC.Lightning.Transaction do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :tx_hash, 1, type: :string, json_name: "txHash"
  field :amount, 2, type: :int64
  field :num_confirmations, 3, type: :int32, json_name: "numConfirmations"
  field :block_hash, 4, type: :string, json_name: "blockHash"
  field :block_height, 5, type: :int32, json_name: "blockHeight"
  field :time_stamp, 6, type: :int64, json_name: "timeStamp"
  field :total_fees, 7, type: :int64, json_name: "totalFees"

  field :dest_addresses, 8,
    repeated: true,
    type: :string,
    json_name: "destAddresses",
    deprecated: true

  field :output_details, 11,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.OutputDetail,
    json_name: "outputDetails"

  field :raw_tx_hex, 9, type: :string, json_name: "rawTxHex"
  field :label, 10, type: :string

  field :previous_outpoints, 12,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PreviousOutPoint,
    json_name: "previousOutpoints"
end

defmodule Lightnex.LNRPC.Lightning.GetTransactionsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :start_height, 1, type: :int32, json_name: "startHeight"
  field :end_height, 2, type: :int32, json_name: "endHeight"
  field :account, 3, type: :string
  field :index_offset, 4, type: :uint32, json_name: "indexOffset"
  field :max_transactions, 5, type: :uint32, json_name: "maxTransactions"
end

defmodule Lightnex.LNRPC.Lightning.TransactionDetails do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :transactions, 1, repeated: true, type: Lightnex.LNRPC.Lightning.Transaction
  field :last_index, 2, type: :uint64, json_name: "lastIndex"
  field :first_index, 3, type: :uint64, json_name: "firstIndex"
end

defmodule Lightnex.LNRPC.Lightning.FeeLimit do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :limit, 0

  field :fixed, 1, type: :int64, oneof: 0
  field :fixed_msat, 3, type: :int64, json_name: "fixedMsat", oneof: 0
  field :percent, 2, type: :int64, oneof: 0
end

defmodule Lightnex.LNRPC.Lightning.SendRequest.DestCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.SendRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :dest, 1, type: :bytes
  field :dest_string, 2, type: :string, json_name: "destString", deprecated: true
  field :amt, 3, type: :int64
  field :amt_msat, 12, type: :int64, json_name: "amtMsat"
  field :payment_hash, 4, type: :bytes, json_name: "paymentHash"
  field :payment_hash_string, 5, type: :string, json_name: "paymentHashString", deprecated: true
  field :payment_request, 6, type: :string, json_name: "paymentRequest"
  field :final_cltv_delta, 7, type: :int32, json_name: "finalCltvDelta"
  field :fee_limit, 8, type: Lightnex.LNRPC.Lightning.FeeLimit, json_name: "feeLimit"
  field :outgoing_chan_id, 9, type: :uint64, json_name: "outgoingChanId", deprecated: false
  field :last_hop_pubkey, 13, type: :bytes, json_name: "lastHopPubkey"
  field :cltv_limit, 10, type: :uint32, json_name: "cltvLimit"

  field :dest_custom_records, 11,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.SendRequest.DestCustomRecordsEntry,
    json_name: "destCustomRecords",
    map: true

  field :allow_self_payment, 14, type: :bool, json_name: "allowSelfPayment"

  field :dest_features, 15,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.FeatureBit,
    json_name: "destFeatures",
    enum: true

  field :payment_addr, 16, type: :bytes, json_name: "paymentAddr"
end

defmodule Lightnex.LNRPC.Lightning.SendResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_error, 1, type: :string, json_name: "paymentError"
  field :payment_preimage, 2, type: :bytes, json_name: "paymentPreimage"
  field :payment_route, 3, type: Lightnex.LNRPC.Lightning.Route, json_name: "paymentRoute"
  field :payment_hash, 4, type: :bytes, json_name: "paymentHash"
end

defmodule Lightnex.LNRPC.Lightning.SendToRouteRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash"
  field :payment_hash_string, 2, type: :string, json_name: "paymentHashString", deprecated: true
  field :route, 4, type: Lightnex.LNRPC.Lightning.Route
end

defmodule Lightnex.LNRPC.Lightning.ChannelAcceptRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_pubkey, 1, type: :bytes, json_name: "nodePubkey"
  field :chain_hash, 2, type: :bytes, json_name: "chainHash"
  field :pending_chan_id, 3, type: :bytes, json_name: "pendingChanId"
  field :funding_amt, 4, type: :uint64, json_name: "fundingAmt"
  field :push_amt, 5, type: :uint64, json_name: "pushAmt"
  field :dust_limit, 6, type: :uint64, json_name: "dustLimit"
  field :max_value_in_flight, 7, type: :uint64, json_name: "maxValueInFlight"
  field :channel_reserve, 8, type: :uint64, json_name: "channelReserve"
  field :min_htlc, 9, type: :uint64, json_name: "minHtlc"
  field :fee_per_kw, 10, type: :uint64, json_name: "feePerKw"
  field :csv_delay, 11, type: :uint32, json_name: "csvDelay"
  field :max_accepted_htlcs, 12, type: :uint32, json_name: "maxAcceptedHtlcs"
  field :channel_flags, 13, type: :uint32, json_name: "channelFlags"

  field :commitment_type, 14,
    type: Lightnex.LNRPC.Lightning.CommitmentType,
    json_name: "commitmentType",
    enum: true

  field :wants_zero_conf, 15, type: :bool, json_name: "wantsZeroConf"
  field :wants_scid_alias, 16, type: :bool, json_name: "wantsScidAlias"
end

defmodule Lightnex.LNRPC.Lightning.ChannelAcceptResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :accept, 1, type: :bool
  field :pending_chan_id, 2, type: :bytes, json_name: "pendingChanId"
  field :error, 3, type: :string
  field :upfront_shutdown, 4, type: :string, json_name: "upfrontShutdown"
  field :csv_delay, 5, type: :uint32, json_name: "csvDelay"
  field :reserve_sat, 6, type: :uint64, json_name: "reserveSat"
  field :in_flight_max_msat, 7, type: :uint64, json_name: "inFlightMaxMsat"
  field :max_htlc_count, 8, type: :uint32, json_name: "maxHtlcCount"
  field :min_htlc_in, 9, type: :uint64, json_name: "minHtlcIn"
  field :min_accept_depth, 10, type: :uint32, json_name: "minAcceptDepth"
  field :zero_conf, 11, type: :bool, json_name: "zeroConf"
end

defmodule Lightnex.LNRPC.Lightning.ChannelPoint do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :funding_txid, 0

  field :funding_txid_bytes, 1, type: :bytes, json_name: "fundingTxidBytes", oneof: 0
  field :funding_txid_str, 2, type: :string, json_name: "fundingTxidStr", oneof: 0
  field :output_index, 3, type: :uint32, json_name: "outputIndex"
end

defmodule Lightnex.LNRPC.Lightning.OutPoint do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid_bytes, 1, type: :bytes, json_name: "txidBytes"
  field :txid_str, 2, type: :string, json_name: "txidStr"
  field :output_index, 3, type: :uint32, json_name: "outputIndex"
end

defmodule Lightnex.LNRPC.Lightning.PreviousOutPoint do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :outpoint, 1, type: :string
  field :is_our_output, 2, type: :bool, json_name: "isOurOutput"
end

defmodule Lightnex.LNRPC.Lightning.LightningAddress do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pubkey, 1, type: :string
  field :host, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.EstimateFeeRequest.AddrToAmountEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :int64
end

defmodule Lightnex.LNRPC.Lightning.EstimateFeeRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :AddrToAmount, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.EstimateFeeRequest.AddrToAmountEntry,
    map: true

  field :target_conf, 2, type: :int32, json_name: "targetConf"
  field :min_confs, 3, type: :int32, json_name: "minConfs"
  field :spend_unconfirmed, 4, type: :bool, json_name: "spendUnconfirmed"

  field :coin_selection_strategy, 5,
    type: Lightnex.LNRPC.Lightning.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
end

defmodule Lightnex.LNRPC.Lightning.EstimateFeeResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :fee_sat, 1, type: :int64, json_name: "feeSat"
  field :feerate_sat_per_byte, 2, type: :int64, json_name: "feerateSatPerByte", deprecated: true
  field :sat_per_vbyte, 3, type: :uint64, json_name: "satPerVbyte"
end

defmodule Lightnex.LNRPC.Lightning.SendManyRequest.AddrToAmountEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :int64
end

defmodule Lightnex.LNRPC.Lightning.SendManyRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :AddrToAmount, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.SendManyRequest.AddrToAmountEntry,
    map: true

  field :target_conf, 3, type: :int32, json_name: "targetConf"
  field :sat_per_vbyte, 4, type: :uint64, json_name: "satPerVbyte"
  field :sat_per_byte, 5, type: :int64, json_name: "satPerByte", deprecated: true
  field :label, 6, type: :string
  field :min_confs, 7, type: :int32, json_name: "minConfs"
  field :spend_unconfirmed, 8, type: :bool, json_name: "spendUnconfirmed"

  field :coin_selection_strategy, 9,
    type: Lightnex.LNRPC.Lightning.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
end

defmodule Lightnex.LNRPC.Lightning.SendManyResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.SendCoinsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :addr, 1, type: :string
  field :amount, 2, type: :int64
  field :target_conf, 3, type: :int32, json_name: "targetConf"
  field :sat_per_vbyte, 4, type: :uint64, json_name: "satPerVbyte"
  field :sat_per_byte, 5, type: :int64, json_name: "satPerByte", deprecated: true
  field :send_all, 6, type: :bool, json_name: "sendAll"
  field :label, 7, type: :string
  field :min_confs, 8, type: :int32, json_name: "minConfs"
  field :spend_unconfirmed, 9, type: :bool, json_name: "spendUnconfirmed"

  field :coin_selection_strategy, 10,
    type: Lightnex.LNRPC.Lightning.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true

  field :outpoints, 11, repeated: true, type: Lightnex.LNRPC.Lightning.OutPoint
end

defmodule Lightnex.LNRPC.Lightning.SendCoinsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.ListUnspentRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :min_confs, 1, type: :int32, json_name: "minConfs"
  field :max_confs, 2, type: :int32, json_name: "maxConfs"
  field :account, 3, type: :string
end

defmodule Lightnex.LNRPC.Lightning.ListUnspentResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :utxos, 1, repeated: true, type: Lightnex.LNRPC.Lightning.Utxo
end

defmodule Lightnex.LNRPC.Lightning.NewAddressRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :type, 1, type: Lightnex.LNRPC.Lightning.AddressType, enum: true
  field :account, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.NewAddressResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :address, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.SignMessageRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :msg, 1, type: :bytes
  field :single_hash, 2, type: :bool, json_name: "singleHash"
end

defmodule Lightnex.LNRPC.Lightning.SignMessageResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :signature, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.VerifyMessageRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :msg, 1, type: :bytes
  field :signature, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.VerifyMessageResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :valid, 1, type: :bool
  field :pubkey, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.ConnectPeerRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :addr, 1, type: Lightnex.LNRPC.Lightning.LightningAddress
  field :perm, 2, type: :bool
  field :timeout, 3, type: :uint64
end

defmodule Lightnex.LNRPC.Lightning.ConnectPeerResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.DisconnectPeerRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pub_key, 1, type: :string, json_name: "pubKey"
end

defmodule Lightnex.LNRPC.Lightning.DisconnectPeerResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.HTLC do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :incoming, 1, type: :bool
  field :amount, 2, type: :int64
  field :hash_lock, 3, type: :bytes, json_name: "hashLock"
  field :expiration_height, 4, type: :uint32, json_name: "expirationHeight"
  field :htlc_index, 5, type: :uint64, json_name: "htlcIndex"
  field :forwarding_channel, 6, type: :uint64, json_name: "forwardingChannel"
  field :forwarding_htlc_index, 7, type: :uint64, json_name: "forwardingHtlcIndex"
  field :locked_in, 8, type: :bool, json_name: "lockedIn"
end

defmodule Lightnex.LNRPC.Lightning.ChannelConstraints do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :csv_delay, 1, type: :uint32, json_name: "csvDelay"
  field :chan_reserve_sat, 2, type: :uint64, json_name: "chanReserveSat"
  field :dust_limit_sat, 3, type: :uint64, json_name: "dustLimitSat"
  field :max_pending_amt_msat, 4, type: :uint64, json_name: "maxPendingAmtMsat"
  field :min_htlc_msat, 5, type: :uint64, json_name: "minHtlcMsat"
  field :max_accepted_htlcs, 6, type: :uint32, json_name: "maxAcceptedHtlcs"
end

defmodule Lightnex.LNRPC.Lightning.Channel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :active, 1, type: :bool
  field :remote_pubkey, 2, type: :string, json_name: "remotePubkey"
  field :channel_point, 3, type: :string, json_name: "channelPoint"
  field :chan_id, 4, type: :uint64, json_name: "chanId", deprecated: false
  field :capacity, 5, type: :int64
  field :local_balance, 6, type: :int64, json_name: "localBalance"
  field :remote_balance, 7, type: :int64, json_name: "remoteBalance"
  field :commit_fee, 8, type: :int64, json_name: "commitFee"
  field :commit_weight, 9, type: :int64, json_name: "commitWeight"
  field :fee_per_kw, 10, type: :int64, json_name: "feePerKw"
  field :unsettled_balance, 11, type: :int64, json_name: "unsettledBalance"
  field :total_satoshis_sent, 12, type: :int64, json_name: "totalSatoshisSent"
  field :total_satoshis_received, 13, type: :int64, json_name: "totalSatoshisReceived"
  field :num_updates, 14, type: :uint64, json_name: "numUpdates"

  field :pending_htlcs, 15,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.HTLC,
    json_name: "pendingHtlcs"

  field :csv_delay, 16, type: :uint32, json_name: "csvDelay", deprecated: true
  field :private, 17, type: :bool
  field :initiator, 18, type: :bool
  field :chan_status_flags, 19, type: :string, json_name: "chanStatusFlags"

  field :local_chan_reserve_sat, 20,
    type: :int64,
    json_name: "localChanReserveSat",
    deprecated: true

  field :remote_chan_reserve_sat, 21,
    type: :int64,
    json_name: "remoteChanReserveSat",
    deprecated: true

  field :static_remote_key, 22, type: :bool, json_name: "staticRemoteKey", deprecated: true

  field :commitment_type, 26,
    type: Lightnex.LNRPC.Lightning.CommitmentType,
    json_name: "commitmentType",
    enum: true

  field :lifetime, 23, type: :int64
  field :uptime, 24, type: :int64
  field :close_address, 25, type: :string, json_name: "closeAddress"
  field :push_amount_sat, 27, type: :uint64, json_name: "pushAmountSat"
  field :thaw_height, 28, type: :uint32, json_name: "thawHeight"

  field :local_constraints, 29,
    type: Lightnex.LNRPC.Lightning.ChannelConstraints,
    json_name: "localConstraints"

  field :remote_constraints, 30,
    type: Lightnex.LNRPC.Lightning.ChannelConstraints,
    json_name: "remoteConstraints"

  field :alias_scids, 31, repeated: true, type: :uint64, json_name: "aliasScids"
  field :zero_conf, 32, type: :bool, json_name: "zeroConf"
  field :zero_conf_confirmed_scid, 33, type: :uint64, json_name: "zeroConfConfirmedScid"
  field :peer_alias, 34, type: :string, json_name: "peerAlias"
  field :peer_scid_alias, 35, type: :uint64, json_name: "peerScidAlias", deprecated: false
  field :memo, 36, type: :string
  field :custom_channel_data, 37, type: :bytes, json_name: "customChannelData"
end

defmodule Lightnex.LNRPC.Lightning.ListChannelsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :active_only, 1, type: :bool, json_name: "activeOnly"
  field :inactive_only, 2, type: :bool, json_name: "inactiveOnly"
  field :public_only, 3, type: :bool, json_name: "publicOnly"
  field :private_only, 4, type: :bool, json_name: "privateOnly"
  field :peer, 5, type: :bytes
  field :peer_alias_lookup, 6, type: :bool, json_name: "peerAliasLookup"
end

defmodule Lightnex.LNRPC.Lightning.ListChannelsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channels, 11, repeated: true, type: Lightnex.LNRPC.Lightning.Channel
end

defmodule Lightnex.LNRPC.Lightning.AliasMap do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :base_scid, 1, type: :uint64, json_name: "baseScid"
  field :aliases, 2, repeated: true, type: :uint64
end

defmodule Lightnex.LNRPC.Lightning.ListAliasesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.ListAliasesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.LNRPC.Lightning.ChannelCloseSummary do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel_point, 1, type: :string, json_name: "channelPoint"
  field :chan_id, 2, type: :uint64, json_name: "chanId", deprecated: false
  field :chain_hash, 3, type: :string, json_name: "chainHash"
  field :closing_tx_hash, 4, type: :string, json_name: "closingTxHash"
  field :remote_pubkey, 5, type: :string, json_name: "remotePubkey"
  field :capacity, 6, type: :int64
  field :close_height, 7, type: :uint32, json_name: "closeHeight"
  field :settled_balance, 8, type: :int64, json_name: "settledBalance"
  field :time_locked_balance, 9, type: :int64, json_name: "timeLockedBalance"

  field :close_type, 10,
    type: Lightnex.LNRPC.Lightning.ChannelCloseSummary.ClosureType,
    json_name: "closeType",
    enum: true

  field :open_initiator, 11,
    type: Lightnex.LNRPC.Lightning.Initiator,
    json_name: "openInitiator",
    enum: true

  field :close_initiator, 12,
    type: Lightnex.LNRPC.Lightning.Initiator,
    json_name: "closeInitiator",
    enum: true

  field :resolutions, 13, repeated: true, type: Lightnex.LNRPC.Lightning.Resolution
  field :alias_scids, 14, repeated: true, type: :uint64, json_name: "aliasScids"

  field :zero_conf_confirmed_scid, 15,
    type: :uint64,
    json_name: "zeroConfConfirmedScid",
    deprecated: false

  field :custom_channel_data, 16, type: :bytes, json_name: "customChannelData"
end

defmodule Lightnex.LNRPC.Lightning.Resolution do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :resolution_type, 1,
    type: Lightnex.LNRPC.Lightning.ResolutionType,
    json_name: "resolutionType",
    enum: true

  field :outcome, 2, type: Lightnex.LNRPC.Lightning.ResolutionOutcome, enum: true
  field :outpoint, 3, type: Lightnex.LNRPC.Lightning.OutPoint
  field :amount_sat, 4, type: :uint64, json_name: "amountSat"
  field :sweep_txid, 5, type: :string, json_name: "sweepTxid"
end

defmodule Lightnex.LNRPC.Lightning.ClosedChannelsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :cooperative, 1, type: :bool
  field :local_force, 2, type: :bool, json_name: "localForce"
  field :remote_force, 3, type: :bool, json_name: "remoteForce"
  field :breach, 4, type: :bool
  field :funding_canceled, 5, type: :bool, json_name: "fundingCanceled"
  field :abandoned, 6, type: :bool
end

defmodule Lightnex.LNRPC.Lightning.ClosedChannelsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channels, 1, repeated: true, type: Lightnex.LNRPC.Lightning.ChannelCloseSummary
end

defmodule Lightnex.LNRPC.Lightning.Peer.FeaturesEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint32
  field :value, 2, type: Lightnex.LNRPC.Lightning.Feature
end

defmodule Lightnex.LNRPC.Lightning.Peer do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pub_key, 1, type: :string, json_name: "pubKey"
  field :address, 3, type: :string
  field :bytes_sent, 4, type: :uint64, json_name: "bytesSent"
  field :bytes_recv, 5, type: :uint64, json_name: "bytesRecv"
  field :sat_sent, 6, type: :int64, json_name: "satSent"
  field :sat_recv, 7, type: :int64, json_name: "satRecv"
  field :inbound, 8, type: :bool
  field :ping_time, 9, type: :int64, json_name: "pingTime"

  field :sync_type, 10,
    type: Lightnex.LNRPC.Lightning.Peer.SyncType,
    json_name: "syncType",
    enum: true

  field :features, 11,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.Peer.FeaturesEntry,
    map: true

  field :errors, 12, repeated: true, type: Lightnex.LNRPC.Lightning.TimestampedError
  field :flap_count, 13, type: :int32, json_name: "flapCount"
  field :last_flap_ns, 14, type: :int64, json_name: "lastFlapNs"
  field :last_ping_payload, 15, type: :bytes, json_name: "lastPingPayload"
end

defmodule Lightnex.LNRPC.Lightning.TimestampedError do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :timestamp, 1, type: :uint64
  field :error, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.ListPeersRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :latest_error, 1, type: :bool, json_name: "latestError"
end

defmodule Lightnex.LNRPC.Lightning.ListPeersResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :peers, 1, repeated: true, type: Lightnex.LNRPC.Lightning.Peer
end

defmodule Lightnex.LNRPC.Lightning.PeerEventSubscription do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.PeerEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pub_key, 1, type: :string, json_name: "pubKey"
  field :type, 2, type: Lightnex.LNRPC.Lightning.PeerEvent.EventType, enum: true
end

defmodule Lightnex.LNRPC.Lightning.GetInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.GetInfoResponse.FeaturesEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint32
  field :value, 2, type: Lightnex.LNRPC.Lightning.Feature
end

defmodule Lightnex.LNRPC.Lightning.GetInfoResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :version, 14, type: :string
  field :commit_hash, 20, type: :string, json_name: "commitHash"
  field :identity_pubkey, 1, type: :string, json_name: "identityPubkey"
  field :alias, 2, type: :string
  field :color, 17, type: :string
  field :num_pending_channels, 3, type: :uint32, json_name: "numPendingChannels"
  field :num_active_channels, 4, type: :uint32, json_name: "numActiveChannels"
  field :num_inactive_channels, 15, type: :uint32, json_name: "numInactiveChannels"
  field :num_peers, 5, type: :uint32, json_name: "numPeers"
  field :block_height, 6, type: :uint32, json_name: "blockHeight"
  field :block_hash, 8, type: :string, json_name: "blockHash"
  field :best_header_timestamp, 13, type: :int64, json_name: "bestHeaderTimestamp"
  field :synced_to_chain, 9, type: :bool, json_name: "syncedToChain"
  field :synced_to_graph, 18, type: :bool, json_name: "syncedToGraph"
  field :testnet, 10, type: :bool, deprecated: true
  field :chains, 16, repeated: true, type: Lightnex.LNRPC.Lightning.Chain
  field :uris, 12, repeated: true, type: :string

  field :features, 19,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.GetInfoResponse.FeaturesEntry,
    map: true

  field :require_htlc_interceptor, 21, type: :bool, json_name: "requireHtlcInterceptor"
  field :store_final_htlc_resolutions, 22, type: :bool, json_name: "storeFinalHtlcResolutions"
end

defmodule Lightnex.LNRPC.Lightning.GetDebugInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.GetDebugInfoResponse.ConfigEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.GetDebugInfoResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :config, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.GetDebugInfoResponse.ConfigEntry,
    map: true

  field :log, 2, repeated: true, type: :string
end

defmodule Lightnex.LNRPC.Lightning.GetRecoveryInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.GetRecoveryInfoResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :recovery_mode, 1, type: :bool, json_name: "recoveryMode"
  field :recovery_finished, 2, type: :bool, json_name: "recoveryFinished"
  field :progress, 3, type: :double
end

defmodule Lightnex.LNRPC.Lightning.Chain do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chain, 1, type: :string, deprecated: true
  field :network, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.ConfirmationUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_sha, 1, type: :bytes, json_name: "blockSha"
  field :block_height, 2, type: :int32, json_name: "blockHeight"
  field :num_confs_left, 3, type: :uint32, json_name: "numConfsLeft"
end

defmodule Lightnex.LNRPC.Lightning.ChannelOpenUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel_point, 1, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "channelPoint"
end

defmodule Lightnex.LNRPC.Lightning.CloseOutput do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amount_sat, 1, type: :int64, json_name: "amountSat"
  field :pk_script, 2, type: :bytes, json_name: "pkScript"
  field :is_local, 3, type: :bool, json_name: "isLocal"
  field :custom_channel_data, 4, type: :bytes, json_name: "customChannelData"
end

defmodule Lightnex.LNRPC.Lightning.ChannelCloseUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :closing_txid, 1, type: :bytes, json_name: "closingTxid"
  field :success, 2, type: :bool

  field :local_close_output, 3,
    type: Lightnex.LNRPC.Lightning.CloseOutput,
    json_name: "localCloseOutput"

  field :remote_close_output, 4,
    type: Lightnex.LNRPC.Lightning.CloseOutput,
    json_name: "remoteCloseOutput"

  field :additional_outputs, 5,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.CloseOutput,
    json_name: "additionalOutputs"
end

defmodule Lightnex.LNRPC.Lightning.CloseChannelRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel_point, 1, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "channelPoint"
  field :force, 2, type: :bool
  field :target_conf, 3, type: :int32, json_name: "targetConf"
  field :sat_per_byte, 4, type: :int64, json_name: "satPerByte", deprecated: true
  field :delivery_address, 5, type: :string, json_name: "deliveryAddress"
  field :sat_per_vbyte, 6, type: :uint64, json_name: "satPerVbyte"
  field :max_fee_per_vbyte, 7, type: :uint64, json_name: "maxFeePerVbyte"
  field :no_wait, 8, type: :bool, json_name: "noWait"
end

defmodule Lightnex.LNRPC.Lightning.CloseStatusUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :update, 0

  field :close_pending, 1,
    type: Lightnex.LNRPC.Lightning.PendingUpdate,
    json_name: "closePending",
    oneof: 0

  field :chan_close, 3,
    type: Lightnex.LNRPC.Lightning.ChannelCloseUpdate,
    json_name: "chanClose",
    oneof: 0

  field :close_instant, 4,
    type: Lightnex.LNRPC.Lightning.InstantUpdate,
    json_name: "closeInstant",
    oneof: 0
end

defmodule Lightnex.LNRPC.Lightning.PendingUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid, 1, type: :bytes
  field :output_index, 2, type: :uint32, json_name: "outputIndex"
  field :fee_per_vbyte, 3, type: :int64, json_name: "feePerVbyte"
  field :local_close_tx, 4, type: :bool, json_name: "localCloseTx"
end

defmodule Lightnex.LNRPC.Lightning.InstantUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :num_pending_htlcs, 1, type: :int32, json_name: "numPendingHtlcs"
end

defmodule Lightnex.LNRPC.Lightning.ReadyForPsbtFunding do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :funding_address, 1, type: :string, json_name: "fundingAddress"
  field :funding_amount, 2, type: :int64, json_name: "fundingAmount"
  field :psbt, 3, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.BatchOpenChannelRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channels, 1, repeated: true, type: Lightnex.LNRPC.Lightning.BatchOpenChannel
  field :target_conf, 2, type: :int32, json_name: "targetConf"
  field :sat_per_vbyte, 3, type: :int64, json_name: "satPerVbyte"
  field :min_confs, 4, type: :int32, json_name: "minConfs"
  field :spend_unconfirmed, 5, type: :bool, json_name: "spendUnconfirmed"
  field :label, 6, type: :string

  field :coin_selection_strategy, 7,
    type: Lightnex.LNRPC.Lightning.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
end

defmodule Lightnex.LNRPC.Lightning.BatchOpenChannel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_pubkey, 1, type: :bytes, json_name: "nodePubkey"
  field :local_funding_amount, 2, type: :int64, json_name: "localFundingAmount"
  field :push_sat, 3, type: :int64, json_name: "pushSat"
  field :private, 4, type: :bool
  field :min_htlc_msat, 5, type: :int64, json_name: "minHtlcMsat"
  field :remote_csv_delay, 6, type: :uint32, json_name: "remoteCsvDelay"
  field :close_address, 7, type: :string, json_name: "closeAddress"
  field :pending_chan_id, 8, type: :bytes, json_name: "pendingChanId"

  field :commitment_type, 9,
    type: Lightnex.LNRPC.Lightning.CommitmentType,
    json_name: "commitmentType",
    enum: true

  field :remote_max_value_in_flight_msat, 10,
    type: :uint64,
    json_name: "remoteMaxValueInFlightMsat"

  field :remote_max_htlcs, 11, type: :uint32, json_name: "remoteMaxHtlcs"
  field :max_local_csv, 12, type: :uint32, json_name: "maxLocalCsv"
  field :zero_conf, 13, type: :bool, json_name: "zeroConf"
  field :scid_alias, 14, type: :bool, json_name: "scidAlias"
  field :base_fee, 15, type: :uint64, json_name: "baseFee"
  field :fee_rate, 16, type: :uint64, json_name: "feeRate"
  field :use_base_fee, 17, type: :bool, json_name: "useBaseFee"
  field :use_fee_rate, 18, type: :bool, json_name: "useFeeRate"
  field :remote_chan_reserve_sat, 19, type: :uint64, json_name: "remoteChanReserveSat"
  field :memo, 20, type: :string
end

defmodule Lightnex.LNRPC.Lightning.BatchOpenChannelResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pending_channels, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PendingUpdate,
    json_name: "pendingChannels"
end

defmodule Lightnex.LNRPC.Lightning.OpenChannelRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :sat_per_vbyte, 1, type: :uint64, json_name: "satPerVbyte"
  field :node_pubkey, 2, type: :bytes, json_name: "nodePubkey"
  field :node_pubkey_string, 3, type: :string, json_name: "nodePubkeyString", deprecated: true
  field :local_funding_amount, 4, type: :int64, json_name: "localFundingAmount"
  field :push_sat, 5, type: :int64, json_name: "pushSat"
  field :target_conf, 6, type: :int32, json_name: "targetConf"
  field :sat_per_byte, 7, type: :int64, json_name: "satPerByte", deprecated: true
  field :private, 8, type: :bool
  field :min_htlc_msat, 9, type: :int64, json_name: "minHtlcMsat"
  field :remote_csv_delay, 10, type: :uint32, json_name: "remoteCsvDelay"
  field :min_confs, 11, type: :int32, json_name: "minConfs"
  field :spend_unconfirmed, 12, type: :bool, json_name: "spendUnconfirmed"
  field :close_address, 13, type: :string, json_name: "closeAddress"
  field :funding_shim, 14, type: Lightnex.LNRPC.Lightning.FundingShim, json_name: "fundingShim"

  field :remote_max_value_in_flight_msat, 15,
    type: :uint64,
    json_name: "remoteMaxValueInFlightMsat"

  field :remote_max_htlcs, 16, type: :uint32, json_name: "remoteMaxHtlcs"
  field :max_local_csv, 17, type: :uint32, json_name: "maxLocalCsv"

  field :commitment_type, 18,
    type: Lightnex.LNRPC.Lightning.CommitmentType,
    json_name: "commitmentType",
    enum: true

  field :zero_conf, 19, type: :bool, json_name: "zeroConf"
  field :scid_alias, 20, type: :bool, json_name: "scidAlias"
  field :base_fee, 21, type: :uint64, json_name: "baseFee"
  field :fee_rate, 22, type: :uint64, json_name: "feeRate"
  field :use_base_fee, 23, type: :bool, json_name: "useBaseFee"
  field :use_fee_rate, 24, type: :bool, json_name: "useFeeRate"
  field :remote_chan_reserve_sat, 25, type: :uint64, json_name: "remoteChanReserveSat"
  field :fund_max, 26, type: :bool, json_name: "fundMax"
  field :memo, 27, type: :string
  field :outpoints, 28, repeated: true, type: Lightnex.LNRPC.Lightning.OutPoint
end

defmodule Lightnex.LNRPC.Lightning.OpenStatusUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :update, 0

  field :chan_pending, 1,
    type: Lightnex.LNRPC.Lightning.PendingUpdate,
    json_name: "chanPending",
    oneof: 0

  field :chan_open, 3,
    type: Lightnex.LNRPC.Lightning.ChannelOpenUpdate,
    json_name: "chanOpen",
    oneof: 0

  field :psbt_fund, 5,
    type: Lightnex.LNRPC.Lightning.ReadyForPsbtFunding,
    json_name: "psbtFund",
    oneof: 0

  field :pending_chan_id, 4, type: :bytes, json_name: "pendingChanId"
end

defmodule Lightnex.LNRPC.Lightning.KeyLocator do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key_family, 1, type: :int32, json_name: "keyFamily"
  field :key_index, 2, type: :int32, json_name: "keyIndex"
end

defmodule Lightnex.LNRPC.Lightning.KeyDescriptor do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_key_bytes, 1, type: :bytes, json_name: "rawKeyBytes"
  field :key_loc, 2, type: Lightnex.LNRPC.Lightning.KeyLocator, json_name: "keyLoc"
end

defmodule Lightnex.LNRPC.Lightning.ChanPointShim do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amt, 1, type: :int64
  field :chan_point, 2, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "chanPoint"
  field :local_key, 3, type: Lightnex.LNRPC.Lightning.KeyDescriptor, json_name: "localKey"
  field :remote_key, 4, type: :bytes, json_name: "remoteKey"
  field :pending_chan_id, 5, type: :bytes, json_name: "pendingChanId"
  field :thaw_height, 6, type: :uint32, json_name: "thawHeight"
  field :musig2, 7, type: :bool
end

defmodule Lightnex.LNRPC.Lightning.PsbtShim do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pending_chan_id, 1, type: :bytes, json_name: "pendingChanId"
  field :base_psbt, 2, type: :bytes, json_name: "basePsbt"
  field :no_publish, 3, type: :bool, json_name: "noPublish"
end

defmodule Lightnex.LNRPC.Lightning.FundingShim do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :shim, 0

  field :chan_point_shim, 1,
    type: Lightnex.LNRPC.Lightning.ChanPointShim,
    json_name: "chanPointShim",
    oneof: 0

  field :psbt_shim, 2, type: Lightnex.LNRPC.Lightning.PsbtShim, json_name: "psbtShim", oneof: 0
end

defmodule Lightnex.LNRPC.Lightning.FundingShimCancel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pending_chan_id, 1, type: :bytes, json_name: "pendingChanId"
end

defmodule Lightnex.LNRPC.Lightning.FundingPsbtVerify do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :funded_psbt, 1, type: :bytes, json_name: "fundedPsbt"
  field :pending_chan_id, 2, type: :bytes, json_name: "pendingChanId"
  field :skip_finalize, 3, type: :bool, json_name: "skipFinalize"
end

defmodule Lightnex.LNRPC.Lightning.FundingPsbtFinalize do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :signed_psbt, 1, type: :bytes, json_name: "signedPsbt"
  field :pending_chan_id, 2, type: :bytes, json_name: "pendingChanId"
  field :final_raw_tx, 3, type: :bytes, json_name: "finalRawTx"
end

defmodule Lightnex.LNRPC.Lightning.FundingTransitionMsg do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :trigger, 0

  field :shim_register, 1,
    type: Lightnex.LNRPC.Lightning.FundingShim,
    json_name: "shimRegister",
    oneof: 0

  field :shim_cancel, 2,
    type: Lightnex.LNRPC.Lightning.FundingShimCancel,
    json_name: "shimCancel",
    oneof: 0

  field :psbt_verify, 3,
    type: Lightnex.LNRPC.Lightning.FundingPsbtVerify,
    json_name: "psbtVerify",
    oneof: 0

  field :psbt_finalize, 4,
    type: Lightnex.LNRPC.Lightning.FundingPsbtFinalize,
    json_name: "psbtFinalize",
    oneof: 0
end

defmodule Lightnex.LNRPC.Lightning.FundingStateStepResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.PendingHTLC do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :incoming, 1, type: :bool
  field :amount, 2, type: :int64
  field :outpoint, 3, type: :string
  field :maturity_height, 4, type: :uint32, json_name: "maturityHeight"
  field :blocks_til_maturity, 5, type: :int32, json_name: "blocksTilMaturity"
  field :stage, 6, type: :uint32
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :include_raw_tx, 1, type: :bool, json_name: "includeRawTx"
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse.PendingChannel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :remote_node_pub, 1, type: :string, json_name: "remoteNodePub"
  field :channel_point, 2, type: :string, json_name: "channelPoint"
  field :capacity, 3, type: :int64
  field :local_balance, 4, type: :int64, json_name: "localBalance"
  field :remote_balance, 5, type: :int64, json_name: "remoteBalance"
  field :local_chan_reserve_sat, 6, type: :int64, json_name: "localChanReserveSat"
  field :remote_chan_reserve_sat, 7, type: :int64, json_name: "remoteChanReserveSat"
  field :initiator, 8, type: Lightnex.LNRPC.Lightning.Initiator, enum: true

  field :commitment_type, 9,
    type: Lightnex.LNRPC.Lightning.CommitmentType,
    json_name: "commitmentType",
    enum: true

  field :num_forwarding_packages, 10, type: :int64, json_name: "numForwardingPackages"
  field :chan_status_flags, 11, type: :string, json_name: "chanStatusFlags"
  field :private, 12, type: :bool
  field :memo, 13, type: :string
  field :custom_channel_data, 34, type: :bytes, json_name: "customChannelData"
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse.PendingOpenChannel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel, 1, type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.PendingChannel
  field :commit_fee, 4, type: :int64, json_name: "commitFee"
  field :commit_weight, 5, type: :int64, json_name: "commitWeight"
  field :fee_per_kw, 6, type: :int64, json_name: "feePerKw"
  field :funding_expiry_blocks, 3, type: :int32, json_name: "fundingExpiryBlocks"
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse.WaitingCloseChannel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel, 1, type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.PendingChannel
  field :limbo_balance, 2, type: :int64, json_name: "limboBalance"
  field :commitments, 3, type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.Commitments
  field :closing_txid, 4, type: :string, json_name: "closingTxid"
  field :closing_tx_hex, 5, type: :string, json_name: "closingTxHex"
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse.Commitments do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :local_txid, 1, type: :string, json_name: "localTxid"
  field :remote_txid, 2, type: :string, json_name: "remoteTxid"
  field :remote_pending_txid, 3, type: :string, json_name: "remotePendingTxid"
  field :local_commit_fee_sat, 4, type: :uint64, json_name: "localCommitFeeSat"
  field :remote_commit_fee_sat, 5, type: :uint64, json_name: "remoteCommitFeeSat"
  field :remote_pending_commit_fee_sat, 6, type: :uint64, json_name: "remotePendingCommitFeeSat"
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse.ClosedChannel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel, 1, type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.PendingChannel
  field :closing_txid, 2, type: :string, json_name: "closingTxid"
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse.ForceClosedChannel do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel, 1, type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.PendingChannel
  field :closing_txid, 2, type: :string, json_name: "closingTxid"
  field :limbo_balance, 3, type: :int64, json_name: "limboBalance"
  field :maturity_height, 4, type: :uint32, json_name: "maturityHeight"
  field :blocks_til_maturity, 5, type: :int32, json_name: "blocksTilMaturity"
  field :recovered_balance, 6, type: :int64, json_name: "recoveredBalance"

  field :pending_htlcs, 8,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PendingHTLC,
    json_name: "pendingHtlcs"

  field :anchor, 9,
    type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.ForceClosedChannel.AnchorState,
    enum: true
end

defmodule Lightnex.LNRPC.Lightning.PendingChannelsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :total_limbo_balance, 1, type: :int64, json_name: "totalLimboBalance"

  field :pending_open_channels, 2,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.PendingOpenChannel,
    json_name: "pendingOpenChannels"

  field :pending_closing_channels, 3,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.ClosedChannel,
    json_name: "pendingClosingChannels",
    deprecated: true

  field :pending_force_closing_channels, 4,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.ForceClosedChannel,
    json_name: "pendingForceClosingChannels"

  field :waiting_close_channels, 5,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PendingChannelsResponse.WaitingCloseChannel,
    json_name: "waitingCloseChannels"
end

defmodule Lightnex.LNRPC.Lightning.ChannelEventSubscription do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.ChannelEventUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :channel, 0

  field :open_channel, 1,
    type: Lightnex.LNRPC.Lightning.Channel,
    json_name: "openChannel",
    oneof: 0

  field :closed_channel, 2,
    type: Lightnex.LNRPC.Lightning.ChannelCloseSummary,
    json_name: "closedChannel",
    oneof: 0

  field :active_channel, 3,
    type: Lightnex.LNRPC.Lightning.ChannelPoint,
    json_name: "activeChannel",
    oneof: 0

  field :inactive_channel, 4,
    type: Lightnex.LNRPC.Lightning.ChannelPoint,
    json_name: "inactiveChannel",
    oneof: 0

  field :pending_open_channel, 6,
    type: Lightnex.LNRPC.Lightning.PendingUpdate,
    json_name: "pendingOpenChannel",
    oneof: 0

  field :fully_resolved_channel, 7,
    type: Lightnex.LNRPC.Lightning.ChannelPoint,
    json_name: "fullyResolvedChannel",
    oneof: 0

  field :channel_funding_timeout, 8,
    type: Lightnex.LNRPC.Lightning.ChannelPoint,
    json_name: "channelFundingTimeout",
    oneof: 0

  field :type, 5, type: Lightnex.LNRPC.Lightning.ChannelEventUpdate.UpdateType, enum: true
end

defmodule Lightnex.LNRPC.Lightning.WalletAccountBalance do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :confirmed_balance, 1, type: :int64, json_name: "confirmedBalance"
  field :unconfirmed_balance, 2, type: :int64, json_name: "unconfirmedBalance"
end

defmodule Lightnex.LNRPC.Lightning.WalletBalanceRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :account, 1, type: :string
  field :min_confs, 2, type: :int32, json_name: "minConfs"
end

defmodule Lightnex.LNRPC.Lightning.WalletBalanceResponse.AccountBalanceEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Lightnex.LNRPC.Lightning.WalletAccountBalance
end

defmodule Lightnex.LNRPC.Lightning.WalletBalanceResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :total_balance, 1, type: :int64, json_name: "totalBalance"
  field :confirmed_balance, 2, type: :int64, json_name: "confirmedBalance"
  field :unconfirmed_balance, 3, type: :int64, json_name: "unconfirmedBalance"
  field :locked_balance, 5, type: :int64, json_name: "lockedBalance"
  field :reserved_balance_anchor_chan, 6, type: :int64, json_name: "reservedBalanceAnchorChan"

  field :account_balance, 4,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.WalletBalanceResponse.AccountBalanceEntry,
    json_name: "accountBalance",
    map: true
end

defmodule Lightnex.LNRPC.Lightning.Amount do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :sat, 1, type: :uint64
  field :msat, 2, type: :uint64
end

defmodule Lightnex.LNRPC.Lightning.ChannelBalanceRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.ChannelBalanceResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :balance, 1, type: :int64, deprecated: true
  field :pending_open_balance, 2, type: :int64, json_name: "pendingOpenBalance", deprecated: true
  field :local_balance, 3, type: Lightnex.LNRPC.Lightning.Amount, json_name: "localBalance"
  field :remote_balance, 4, type: Lightnex.LNRPC.Lightning.Amount, json_name: "remoteBalance"

  field :unsettled_local_balance, 5,
    type: Lightnex.LNRPC.Lightning.Amount,
    json_name: "unsettledLocalBalance"

  field :unsettled_remote_balance, 6,
    type: Lightnex.LNRPC.Lightning.Amount,
    json_name: "unsettledRemoteBalance"

  field :pending_open_local_balance, 7,
    type: Lightnex.LNRPC.Lightning.Amount,
    json_name: "pendingOpenLocalBalance"

  field :pending_open_remote_balance, 8,
    type: Lightnex.LNRPC.Lightning.Amount,
    json_name: "pendingOpenRemoteBalance"

  field :custom_channel_data, 9, type: :bytes, json_name: "customChannelData"
end

defmodule Lightnex.LNRPC.Lightning.QueryRoutesRequest.DestCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.QueryRoutesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pub_key, 1, type: :string, json_name: "pubKey"
  field :amt, 2, type: :int64
  field :amt_msat, 12, type: :int64, json_name: "amtMsat"
  field :final_cltv_delta, 4, type: :int32, json_name: "finalCltvDelta"
  field :fee_limit, 5, type: Lightnex.LNRPC.Lightning.FeeLimit, json_name: "feeLimit"
  field :ignored_nodes, 6, repeated: true, type: :bytes, json_name: "ignoredNodes"

  field :ignored_edges, 7,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.EdgeLocator,
    json_name: "ignoredEdges",
    deprecated: true

  field :source_pub_key, 8, type: :string, json_name: "sourcePubKey"
  field :use_mission_control, 9, type: :bool, json_name: "useMissionControl"

  field :ignored_pairs, 10,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.NodePair,
    json_name: "ignoredPairs"

  field :cltv_limit, 11, type: :uint32, json_name: "cltvLimit"

  field :dest_custom_records, 13,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.QueryRoutesRequest.DestCustomRecordsEntry,
    json_name: "destCustomRecords",
    map: true

  field :outgoing_chan_id, 14, type: :uint64, json_name: "outgoingChanId", deprecated: false
  field :last_hop_pubkey, 15, type: :bytes, json_name: "lastHopPubkey"

  field :route_hints, 16,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.RouteHint,
    json_name: "routeHints"

  field :blinded_payment_paths, 19,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.BlindedPaymentPath,
    json_name: "blindedPaymentPaths"

  field :dest_features, 17,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.FeatureBit,
    json_name: "destFeatures",
    enum: true

  field :time_pref, 18, type: :double, json_name: "timePref"
end

defmodule Lightnex.LNRPC.Lightning.NodePair do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from, 1, type: :bytes
  field :to, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.EdgeLocator do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel_id, 1, type: :uint64, json_name: "channelId", deprecated: false
  field :direction_reverse, 2, type: :bool, json_name: "directionReverse"
end

defmodule Lightnex.LNRPC.Lightning.QueryRoutesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :routes, 1, repeated: true, type: Lightnex.LNRPC.Lightning.Route
  field :success_prob, 2, type: :double, json_name: "successProb"
end

defmodule Lightnex.LNRPC.Lightning.Hop.CustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.Hop do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false
  field :chan_capacity, 2, type: :int64, json_name: "chanCapacity", deprecated: true
  field :amt_to_forward, 3, type: :int64, json_name: "amtToForward", deprecated: true
  field :fee, 4, type: :int64, deprecated: true
  field :expiry, 5, type: :uint32
  field :amt_to_forward_msat, 6, type: :int64, json_name: "amtToForwardMsat"
  field :fee_msat, 7, type: :int64, json_name: "feeMsat"
  field :pub_key, 8, type: :string, json_name: "pubKey"
  field :tlv_payload, 9, type: :bool, json_name: "tlvPayload", deprecated: true
  field :mpp_record, 10, type: Lightnex.LNRPC.Lightning.MPPRecord, json_name: "mppRecord"
  field :amp_record, 12, type: Lightnex.LNRPC.Lightning.AMPRecord, json_name: "ampRecord"

  field :custom_records, 11,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.Hop.CustomRecordsEntry,
    json_name: "customRecords",
    map: true

  field :metadata, 13, type: :bytes
  field :blinding_point, 14, type: :bytes, json_name: "blindingPoint"
  field :encrypted_data, 15, type: :bytes, json_name: "encryptedData"
  field :total_amt_msat, 16, type: :uint64, json_name: "totalAmtMsat"
end

defmodule Lightnex.LNRPC.Lightning.MPPRecord do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_addr, 11, type: :bytes, json_name: "paymentAddr"
  field :total_amt_msat, 10, type: :int64, json_name: "totalAmtMsat"
end

defmodule Lightnex.LNRPC.Lightning.AMPRecord do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :root_share, 1, type: :bytes, json_name: "rootShare"
  field :set_id, 2, type: :bytes, json_name: "setId"
  field :child_index, 3, type: :uint32, json_name: "childIndex"
end

defmodule Lightnex.LNRPC.Lightning.Route do
  @moduledoc """
  A path through the channel graph which runs over one or more channels in
  succession. This struct carries all the information required to craft the
  Sphinx onion packet, and send the payment along the first hop in the path. A
  route is only selected as valid if all the channels have sufficient capacity to
  carry the initial payment amount after fees are accounted for.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :total_time_lock, 1, type: :uint32, json_name: "totalTimeLock"
  field :total_fees, 2, type: :int64, json_name: "totalFees", deprecated: true
  field :total_amt, 3, type: :int64, json_name: "totalAmt", deprecated: true
  field :hops, 4, repeated: true, type: Lightnex.LNRPC.Lightning.Hop
  field :total_fees_msat, 5, type: :int64, json_name: "totalFeesMsat"
  field :total_amt_msat, 6, type: :int64, json_name: "totalAmtMsat"
  field :first_hop_amount_msat, 7, type: :int64, json_name: "firstHopAmountMsat"
  field :custom_channel_data, 8, type: :bytes, json_name: "customChannelData"
end

defmodule Lightnex.LNRPC.Lightning.NodeInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pub_key, 1, type: :string, json_name: "pubKey"
  field :include_channels, 2, type: :bool, json_name: "includeChannels"
end

defmodule Lightnex.LNRPC.Lightning.NodeInfo do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node, 1, type: Lightnex.LNRPC.Lightning.LightningNode
  field :num_channels, 2, type: :uint32, json_name: "numChannels"
  field :total_capacity, 3, type: :int64, json_name: "totalCapacity"
  field :channels, 4, repeated: true, type: Lightnex.LNRPC.Lightning.ChannelEdge
end

defmodule Lightnex.LNRPC.Lightning.LightningNode.FeaturesEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint32
  field :value, 2, type: Lightnex.LNRPC.Lightning.Feature
end

defmodule Lightnex.LNRPC.Lightning.LightningNode.CustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.LightningNode do
  @moduledoc """
  An individual vertex/node within the channel graph. A node is
  connected to other nodes by one or more channel edges emanating from it. As the
  graph is directed, a node will also have an incoming edge attached to it for
  each outgoing edge.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :last_update, 1, type: :uint32, json_name: "lastUpdate"
  field :pub_key, 2, type: :string, json_name: "pubKey"
  field :alias, 3, type: :string
  field :addresses, 4, repeated: true, type: Lightnex.LNRPC.Lightning.NodeAddress
  field :color, 5, type: :string

  field :features, 6,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.LightningNode.FeaturesEntry,
    map: true

  field :custom_records, 7,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.LightningNode.CustomRecordsEntry,
    json_name: "customRecords",
    map: true
end

defmodule Lightnex.LNRPC.Lightning.NodeAddress do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :network, 1, type: :string
  field :addr, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.RoutingPolicy.CustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.RoutingPolicy do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :time_lock_delta, 1, type: :uint32, json_name: "timeLockDelta"
  field :min_htlc, 2, type: :int64, json_name: "minHtlc"
  field :fee_base_msat, 3, type: :int64, json_name: "feeBaseMsat"
  field :fee_rate_milli_msat, 4, type: :int64, json_name: "feeRateMilliMsat"
  field :disabled, 5, type: :bool
  field :max_htlc_msat, 6, type: :uint64, json_name: "maxHtlcMsat"
  field :last_update, 7, type: :uint32, json_name: "lastUpdate"

  field :custom_records, 8,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.RoutingPolicy.CustomRecordsEntry,
    json_name: "customRecords",
    map: true

  field :inbound_fee_base_msat, 9, type: :int32, json_name: "inboundFeeBaseMsat"
  field :inbound_fee_rate_milli_msat, 10, type: :int32, json_name: "inboundFeeRateMilliMsat"
end

defmodule Lightnex.LNRPC.Lightning.ChannelEdge.CustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.ChannelEdge do
  @moduledoc """
  A fully authenticated channel along with all its unique attributes.
  Once an authenticated channel announcement has been processed on the network,
  then an instance of ChannelEdgeInfo encapsulating the channels attributes is
  stored. The other portions relevant to routing policy of a channel are stored
  within a ChannelEdgePolicy for each direction of the channel.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel_id, 1, type: :uint64, json_name: "channelId", deprecated: false
  field :chan_point, 2, type: :string, json_name: "chanPoint"
  field :last_update, 3, type: :uint32, json_name: "lastUpdate", deprecated: true
  field :node1_pub, 4, type: :string, json_name: "node1Pub"
  field :node2_pub, 5, type: :string, json_name: "node2Pub"
  field :capacity, 6, type: :int64
  field :node1_policy, 7, type: Lightnex.LNRPC.Lightning.RoutingPolicy, json_name: "node1Policy"
  field :node2_policy, 8, type: Lightnex.LNRPC.Lightning.RoutingPolicy, json_name: "node2Policy"

  field :custom_records, 9,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ChannelEdge.CustomRecordsEntry,
    json_name: "customRecords",
    map: true
end

defmodule Lightnex.LNRPC.Lightning.ChannelGraphRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :include_unannounced, 1, type: :bool, json_name: "includeUnannounced"
end

defmodule Lightnex.LNRPC.Lightning.ChannelGraph do
  @moduledoc """
  Returns a new instance of the directed channel graph.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :nodes, 1, repeated: true, type: Lightnex.LNRPC.Lightning.LightningNode
  field :edges, 2, repeated: true, type: Lightnex.LNRPC.Lightning.ChannelEdge
end

defmodule Lightnex.LNRPC.Lightning.NodeMetricsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :types, 1, repeated: true, type: Lightnex.LNRPC.Lightning.NodeMetricType, enum: true
end

defmodule Lightnex.LNRPC.Lightning.NodeMetricsResponse.BetweennessCentralityEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Lightnex.LNRPC.Lightning.FloatMetric
end

defmodule Lightnex.LNRPC.Lightning.NodeMetricsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :betweenness_centrality, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.NodeMetricsResponse.BetweennessCentralityEntry,
    json_name: "betweennessCentrality",
    map: true
end

defmodule Lightnex.LNRPC.Lightning.FloatMetric do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :value, 1, type: :double
  field :normalized_value, 2, type: :double, json_name: "normalizedValue"
end

defmodule Lightnex.LNRPC.Lightning.ChanInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false
  field :chan_point, 2, type: :string, json_name: "chanPoint"
end

defmodule Lightnex.LNRPC.Lightning.NetworkInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.NetworkInfo do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :graph_diameter, 1, type: :uint32, json_name: "graphDiameter"
  field :avg_out_degree, 2, type: :double, json_name: "avgOutDegree"
  field :max_out_degree, 3, type: :uint32, json_name: "maxOutDegree"
  field :num_nodes, 4, type: :uint32, json_name: "numNodes"
  field :num_channels, 5, type: :uint32, json_name: "numChannels"
  field :total_network_capacity, 6, type: :int64, json_name: "totalNetworkCapacity"
  field :avg_channel_size, 7, type: :double, json_name: "avgChannelSize"
  field :min_channel_size, 8, type: :int64, json_name: "minChannelSize"
  field :max_channel_size, 9, type: :int64, json_name: "maxChannelSize"
  field :median_channel_size_sat, 10, type: :int64, json_name: "medianChannelSizeSat"
  field :num_zombie_chans, 11, type: :uint64, json_name: "numZombieChans"
end

defmodule Lightnex.LNRPC.Lightning.StopRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.StopResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.GraphTopologySubscription do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.GraphTopologyUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_updates, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.NodeUpdate,
    json_name: "nodeUpdates"

  field :channel_updates, 2,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ChannelEdgeUpdate,
    json_name: "channelUpdates"

  field :closed_chans, 3,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ClosedChannelUpdate,
    json_name: "closedChans"
end

defmodule Lightnex.LNRPC.Lightning.NodeUpdate.FeaturesEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint32
  field :value, 2, type: Lightnex.LNRPC.Lightning.Feature
end

defmodule Lightnex.LNRPC.Lightning.NodeUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :addresses, 1, repeated: true, type: :string, deprecated: true
  field :identity_key, 2, type: :string, json_name: "identityKey"
  field :global_features, 3, type: :bytes, json_name: "globalFeatures", deprecated: true
  field :alias, 4, type: :string
  field :color, 5, type: :string

  field :node_addresses, 7,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.NodeAddress,
    json_name: "nodeAddresses"

  field :features, 6,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.NodeUpdate.FeaturesEntry,
    map: true
end

defmodule Lightnex.LNRPC.Lightning.ChannelEdgeUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false
  field :chan_point, 2, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "chanPoint"
  field :capacity, 3, type: :int64

  field :routing_policy, 4,
    type: Lightnex.LNRPC.Lightning.RoutingPolicy,
    json_name: "routingPolicy"

  field :advertising_node, 5, type: :string, json_name: "advertisingNode"
  field :connecting_node, 6, type: :string, json_name: "connectingNode"
end

defmodule Lightnex.LNRPC.Lightning.ClosedChannelUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false
  field :capacity, 2, type: :int64
  field :closed_height, 3, type: :uint32, json_name: "closedHeight"
  field :chan_point, 4, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "chanPoint"
end

defmodule Lightnex.LNRPC.Lightning.HopHint do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_id, 1, type: :string, json_name: "nodeId"
  field :chan_id, 2, type: :uint64, json_name: "chanId", deprecated: false
  field :fee_base_msat, 3, type: :uint32, json_name: "feeBaseMsat"
  field :fee_proportional_millionths, 4, type: :uint32, json_name: "feeProportionalMillionths"
  field :cltv_expiry_delta, 5, type: :uint32, json_name: "cltvExpiryDelta"
end

defmodule Lightnex.LNRPC.Lightning.SetID do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :set_id, 1, type: :bytes, json_name: "setId"
end

defmodule Lightnex.LNRPC.Lightning.RouteHint do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :hop_hints, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.HopHint,
    json_name: "hopHints"
end

defmodule Lightnex.LNRPC.Lightning.BlindedPaymentPath do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :blinded_path, 1, type: Lightnex.LNRPC.Lightning.BlindedPath, json_name: "blindedPath"
  field :base_fee_msat, 2, type: :uint64, json_name: "baseFeeMsat"
  field :proportional_fee_rate, 3, type: :uint32, json_name: "proportionalFeeRate"
  field :total_cltv_delta, 4, type: :uint32, json_name: "totalCltvDelta"
  field :htlc_min_msat, 5, type: :uint64, json_name: "htlcMinMsat"
  field :htlc_max_msat, 6, type: :uint64, json_name: "htlcMaxMsat"
  field :features, 7, repeated: true, type: Lightnex.LNRPC.Lightning.FeatureBit, enum: true
end

defmodule Lightnex.LNRPC.Lightning.BlindedPath do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :introduction_node, 1, type: :bytes, json_name: "introductionNode"
  field :blinding_point, 2, type: :bytes, json_name: "blindingPoint"

  field :blinded_hops, 3,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.BlindedHop,
    json_name: "blindedHops"
end

defmodule Lightnex.LNRPC.Lightning.BlindedHop do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :blinded_node, 1, type: :bytes, json_name: "blindedNode"
  field :encrypted_data, 2, type: :bytes, json_name: "encryptedData"
end

defmodule Lightnex.LNRPC.Lightning.AMPInvoiceState do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :state, 1, type: Lightnex.LNRPC.Lightning.InvoiceHTLCState, enum: true
  field :settle_index, 2, type: :uint64, json_name: "settleIndex"
  field :settle_time, 3, type: :int64, json_name: "settleTime"
  field :amt_paid_msat, 5, type: :int64, json_name: "amtPaidMsat"
end

defmodule Lightnex.LNRPC.Lightning.Invoice.FeaturesEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint32
  field :value, 2, type: Lightnex.LNRPC.Lightning.Feature
end

defmodule Lightnex.LNRPC.Lightning.Invoice.AmpInvoiceStateEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Lightnex.LNRPC.Lightning.AMPInvoiceState
end

defmodule Lightnex.LNRPC.Lightning.Invoice do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :memo, 1, type: :string
  field :r_preimage, 3, type: :bytes, json_name: "rPreimage"
  field :r_hash, 4, type: :bytes, json_name: "rHash"
  field :value, 5, type: :int64
  field :value_msat, 23, type: :int64, json_name: "valueMsat"
  field :settled, 6, type: :bool, deprecated: true
  field :creation_date, 7, type: :int64, json_name: "creationDate"
  field :settle_date, 8, type: :int64, json_name: "settleDate"
  field :payment_request, 9, type: :string, json_name: "paymentRequest"
  field :description_hash, 10, type: :bytes, json_name: "descriptionHash"
  field :expiry, 11, type: :int64
  field :fallback_addr, 12, type: :string, json_name: "fallbackAddr"
  field :cltv_expiry, 13, type: :uint64, json_name: "cltvExpiry"

  field :route_hints, 14,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.RouteHint,
    json_name: "routeHints"

  field :private, 15, type: :bool
  field :add_index, 16, type: :uint64, json_name: "addIndex"
  field :settle_index, 17, type: :uint64, json_name: "settleIndex"
  field :amt_paid, 18, type: :int64, json_name: "amtPaid", deprecated: true
  field :amt_paid_sat, 19, type: :int64, json_name: "amtPaidSat"
  field :amt_paid_msat, 20, type: :int64, json_name: "amtPaidMsat"
  field :state, 21, type: Lightnex.LNRPC.Lightning.Invoice.InvoiceState, enum: true
  field :htlcs, 22, repeated: true, type: Lightnex.LNRPC.Lightning.InvoiceHTLC

  field :features, 24,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.Invoice.FeaturesEntry,
    map: true

  field :is_keysend, 25, type: :bool, json_name: "isKeysend"
  field :payment_addr, 26, type: :bytes, json_name: "paymentAddr"
  field :is_amp, 27, type: :bool, json_name: "isAmp"

  field :amp_invoice_state, 28,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.Invoice.AmpInvoiceStateEntry,
    json_name: "ampInvoiceState",
    map: true

  field :is_blinded, 29, type: :bool, json_name: "isBlinded"

  field :blinded_path_config, 30,
    type: Lightnex.LNRPC.Lightning.BlindedPathConfig,
    json_name: "blindedPathConfig"
end

defmodule Lightnex.LNRPC.Lightning.BlindedPathConfig do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :min_num_real_hops, 1, proto3_optional: true, type: :uint32, json_name: "minNumRealHops"
  field :num_hops, 2, proto3_optional: true, type: :uint32, json_name: "numHops"
  field :max_num_paths, 3, proto3_optional: true, type: :uint32, json_name: "maxNumPaths"
  field :node_omission_list, 4, repeated: true, type: :bytes, json_name: "nodeOmissionList"
end

defmodule Lightnex.LNRPC.Lightning.InvoiceHTLC.CustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.InvoiceHTLC do
  @moduledoc """
  Details of an HTLC that paid to an invoice
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId", deprecated: false
  field :htlc_index, 2, type: :uint64, json_name: "htlcIndex"
  field :amt_msat, 3, type: :uint64, json_name: "amtMsat"
  field :accept_height, 4, type: :int32, json_name: "acceptHeight"
  field :accept_time, 5, type: :int64, json_name: "acceptTime"
  field :resolve_time, 6, type: :int64, json_name: "resolveTime"
  field :expiry_height, 7, type: :int32, json_name: "expiryHeight"
  field :state, 8, type: Lightnex.LNRPC.Lightning.InvoiceHTLCState, enum: true

  field :custom_records, 9,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.InvoiceHTLC.CustomRecordsEntry,
    json_name: "customRecords",
    map: true

  field :mpp_total_amt_msat, 10, type: :uint64, json_name: "mppTotalAmtMsat"
  field :amp, 11, type: Lightnex.LNRPC.Lightning.AMP
  field :custom_channel_data, 12, type: :bytes, json_name: "customChannelData"
end

defmodule Lightnex.LNRPC.Lightning.AMP do
  @moduledoc """
  Details specific to AMP HTLCs.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :root_share, 1, type: :bytes, json_name: "rootShare"
  field :set_id, 2, type: :bytes, json_name: "setId"
  field :child_index, 3, type: :uint32, json_name: "childIndex"
  field :hash, 4, type: :bytes
  field :preimage, 5, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.AddInvoiceResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :r_hash, 1, type: :bytes, json_name: "rHash"
  field :payment_request, 2, type: :string, json_name: "paymentRequest"
  field :add_index, 16, type: :uint64, json_name: "addIndex"
  field :payment_addr, 17, type: :bytes, json_name: "paymentAddr"
end

defmodule Lightnex.LNRPC.Lightning.PaymentHash do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :r_hash_str, 1, type: :string, json_name: "rHashStr", deprecated: true
  field :r_hash, 2, type: :bytes, json_name: "rHash"
end

defmodule Lightnex.LNRPC.Lightning.ListInvoiceRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pending_only, 1, type: :bool, json_name: "pendingOnly"
  field :index_offset, 4, type: :uint64, json_name: "indexOffset"
  field :num_max_invoices, 5, type: :uint64, json_name: "numMaxInvoices"
  field :reversed, 6, type: :bool
  field :creation_date_start, 7, type: :uint64, json_name: "creationDateStart"
  field :creation_date_end, 8, type: :uint64, json_name: "creationDateEnd"
end

defmodule Lightnex.LNRPC.Lightning.ListInvoiceResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :invoices, 1, repeated: true, type: Lightnex.LNRPC.Lightning.Invoice
  field :last_index_offset, 2, type: :uint64, json_name: "lastIndexOffset"
  field :first_index_offset, 3, type: :uint64, json_name: "firstIndexOffset"
end

defmodule Lightnex.LNRPC.Lightning.InvoiceSubscription do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :add_index, 1, type: :uint64, json_name: "addIndex"
  field :settle_index, 2, type: :uint64, json_name: "settleIndex"
end

defmodule Lightnex.LNRPC.Lightning.Payment.FirstHopCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.Payment do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :string, json_name: "paymentHash"
  field :value, 2, type: :int64, deprecated: true
  field :creation_date, 3, type: :int64, json_name: "creationDate", deprecated: true
  field :fee, 5, type: :int64, deprecated: true
  field :payment_preimage, 6, type: :string, json_name: "paymentPreimage"
  field :value_sat, 7, type: :int64, json_name: "valueSat"
  field :value_msat, 8, type: :int64, json_name: "valueMsat"
  field :payment_request, 9, type: :string, json_name: "paymentRequest"
  field :status, 10, type: Lightnex.LNRPC.Lightning.Payment.PaymentStatus, enum: true
  field :fee_sat, 11, type: :int64, json_name: "feeSat"
  field :fee_msat, 12, type: :int64, json_name: "feeMsat"
  field :creation_time_ns, 13, type: :int64, json_name: "creationTimeNs"
  field :htlcs, 14, repeated: true, type: Lightnex.LNRPC.Lightning.HTLCAttempt
  field :payment_index, 15, type: :uint64, json_name: "paymentIndex"

  field :failure_reason, 16,
    type: Lightnex.LNRPC.Lightning.PaymentFailureReason,
    json_name: "failureReason",
    enum: true

  field :first_hop_custom_records, 17,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.Payment.FirstHopCustomRecordsEntry,
    json_name: "firstHopCustomRecords",
    map: true
end

defmodule Lightnex.LNRPC.Lightning.HTLCAttempt do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :attempt_id, 7, type: :uint64, json_name: "attemptId"
  field :status, 1, type: Lightnex.LNRPC.Lightning.HTLCAttempt.HTLCStatus, enum: true
  field :route, 2, type: Lightnex.LNRPC.Lightning.Route
  field :attempt_time_ns, 3, type: :int64, json_name: "attemptTimeNs"
  field :resolve_time_ns, 4, type: :int64, json_name: "resolveTimeNs"
  field :failure, 5, type: Lightnex.LNRPC.Lightning.Failure
  field :preimage, 6, type: :bytes
end

defmodule Lightnex.LNRPC.Lightning.ListPaymentsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :include_incomplete, 1, type: :bool, json_name: "includeIncomplete"
  field :index_offset, 2, type: :uint64, json_name: "indexOffset"
  field :max_payments, 3, type: :uint64, json_name: "maxPayments"
  field :reversed, 4, type: :bool
  field :count_total_payments, 5, type: :bool, json_name: "countTotalPayments"
  field :creation_date_start, 6, type: :uint64, json_name: "creationDateStart"
  field :creation_date_end, 7, type: :uint64, json_name: "creationDateEnd"
end

defmodule Lightnex.LNRPC.Lightning.ListPaymentsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payments, 1, repeated: true, type: Lightnex.LNRPC.Lightning.Payment
  field :first_index_offset, 2, type: :uint64, json_name: "firstIndexOffset"
  field :last_index_offset, 3, type: :uint64, json_name: "lastIndexOffset"
  field :total_num_payments, 4, type: :uint64, json_name: "totalNumPayments"
end

defmodule Lightnex.LNRPC.Lightning.DeletePaymentRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash"
  field :failed_htlcs_only, 2, type: :bool, json_name: "failedHtlcsOnly"
end

defmodule Lightnex.LNRPC.Lightning.DeleteAllPaymentsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :failed_payments_only, 1, type: :bool, json_name: "failedPaymentsOnly"
  field :failed_htlcs_only, 2, type: :bool, json_name: "failedHtlcsOnly"
  field :all_payments, 3, type: :bool, json_name: "allPayments"
end

defmodule Lightnex.LNRPC.Lightning.DeletePaymentResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.DeleteAllPaymentsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.AbandonChannelRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel_point, 1, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "channelPoint"
  field :pending_funding_shim_only, 2, type: :bool, json_name: "pendingFundingShimOnly"
  field :i_know_what_i_am_doing, 3, type: :bool, json_name: "iKnowWhatIAmDoing"
end

defmodule Lightnex.LNRPC.Lightning.AbandonChannelResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.DebugLevelRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :show, 1, type: :bool
  field :level_spec, 2, type: :string, json_name: "levelSpec"
end

defmodule Lightnex.LNRPC.Lightning.DebugLevelResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :sub_systems, 1, type: :string, json_name: "subSystems"
end

defmodule Lightnex.LNRPC.Lightning.PayReqString do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pay_req, 1, type: :string, json_name: "payReq"
end

defmodule Lightnex.LNRPC.Lightning.PayReq.FeaturesEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint32
  field :value, 2, type: Lightnex.LNRPC.Lightning.Feature
end

defmodule Lightnex.LNRPC.Lightning.PayReq do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :destination, 1, type: :string
  field :payment_hash, 2, type: :string, json_name: "paymentHash"
  field :num_satoshis, 3, type: :int64, json_name: "numSatoshis"
  field :timestamp, 4, type: :int64
  field :expiry, 5, type: :int64
  field :description, 6, type: :string
  field :description_hash, 7, type: :string, json_name: "descriptionHash"
  field :fallback_addr, 8, type: :string, json_name: "fallbackAddr"
  field :cltv_expiry, 9, type: :int64, json_name: "cltvExpiry"

  field :route_hints, 10,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.RouteHint,
    json_name: "routeHints"

  field :payment_addr, 11, type: :bytes, json_name: "paymentAddr"
  field :num_msat, 12, type: :int64, json_name: "numMsat"

  field :features, 13,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.PayReq.FeaturesEntry,
    map: true

  field :blinded_paths, 14,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.BlindedPaymentPath,
    json_name: "blindedPaths"
end

defmodule Lightnex.LNRPC.Lightning.Feature do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :name, 2, type: :string
  field :is_required, 3, type: :bool, json_name: "isRequired"
  field :is_known, 4, type: :bool, json_name: "isKnown"
end

defmodule Lightnex.LNRPC.Lightning.FeeReportRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.ChannelFeeReport do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 5, type: :uint64, json_name: "chanId", deprecated: false
  field :channel_point, 1, type: :string, json_name: "channelPoint"
  field :base_fee_msat, 2, type: :int64, json_name: "baseFeeMsat"
  field :fee_per_mil, 3, type: :int64, json_name: "feePerMil"
  field :fee_rate, 4, type: :double, json_name: "feeRate"
  field :inbound_base_fee_msat, 6, type: :int32, json_name: "inboundBaseFeeMsat"
  field :inbound_fee_per_mil, 7, type: :int32, json_name: "inboundFeePerMil"
end

defmodule Lightnex.LNRPC.Lightning.FeeReportResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :channel_fees, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ChannelFeeReport,
    json_name: "channelFees"

  field :day_fee_sum, 2, type: :uint64, json_name: "dayFeeSum"
  field :week_fee_sum, 3, type: :uint64, json_name: "weekFeeSum"
  field :month_fee_sum, 4, type: :uint64, json_name: "monthFeeSum"
end

defmodule Lightnex.LNRPC.Lightning.InboundFee do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :base_fee_msat, 1, type: :int32, json_name: "baseFeeMsat"
  field :fee_rate_ppm, 2, type: :int32, json_name: "feeRatePpm"
end

defmodule Lightnex.LNRPC.Lightning.PolicyUpdateRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :scope, 0

  field :global, 1, type: :bool, oneof: 0

  field :chan_point, 2,
    type: Lightnex.LNRPC.Lightning.ChannelPoint,
    json_name: "chanPoint",
    oneof: 0

  field :base_fee_msat, 3, type: :int64, json_name: "baseFeeMsat"
  field :fee_rate, 4, type: :double, json_name: "feeRate"
  field :fee_rate_ppm, 9, type: :uint32, json_name: "feeRatePpm"
  field :time_lock_delta, 5, type: :uint32, json_name: "timeLockDelta"
  field :max_htlc_msat, 6, type: :uint64, json_name: "maxHtlcMsat"
  field :min_htlc_msat, 7, type: :uint64, json_name: "minHtlcMsat"
  field :min_htlc_msat_specified, 8, type: :bool, json_name: "minHtlcMsatSpecified"
  field :inbound_fee, 10, type: Lightnex.LNRPC.Lightning.InboundFee, json_name: "inboundFee"
  field :create_missing_edge, 11, type: :bool, json_name: "createMissingEdge"
end

defmodule Lightnex.LNRPC.Lightning.FailedUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :outpoint, 1, type: Lightnex.LNRPC.Lightning.OutPoint
  field :reason, 2, type: Lightnex.LNRPC.Lightning.UpdateFailure, enum: true
  field :update_error, 3, type: :string, json_name: "updateError"
end

defmodule Lightnex.LNRPC.Lightning.PolicyUpdateResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :failed_updates, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.FailedUpdate,
    json_name: "failedUpdates"
end

defmodule Lightnex.LNRPC.Lightning.ForwardingHistoryRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :start_time, 1, type: :uint64, json_name: "startTime"
  field :end_time, 2, type: :uint64, json_name: "endTime"
  field :index_offset, 3, type: :uint32, json_name: "indexOffset"
  field :num_max_events, 4, type: :uint32, json_name: "numMaxEvents"
  field :peer_alias_lookup, 5, type: :bool, json_name: "peerAliasLookup"
end

defmodule Lightnex.LNRPC.Lightning.ForwardingEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :timestamp, 1, type: :uint64, deprecated: true
  field :chan_id_in, 2, type: :uint64, json_name: "chanIdIn", deprecated: false
  field :chan_id_out, 4, type: :uint64, json_name: "chanIdOut", deprecated: false
  field :amt_in, 5, type: :uint64, json_name: "amtIn"
  field :amt_out, 6, type: :uint64, json_name: "amtOut"
  field :fee, 7, type: :uint64
  field :fee_msat, 8, type: :uint64, json_name: "feeMsat"
  field :amt_in_msat, 9, type: :uint64, json_name: "amtInMsat"
  field :amt_out_msat, 10, type: :uint64, json_name: "amtOutMsat"
  field :timestamp_ns, 11, type: :uint64, json_name: "timestampNs"
  field :peer_alias_in, 12, type: :string, json_name: "peerAliasIn"
  field :peer_alias_out, 13, type: :string, json_name: "peerAliasOut"
  field :incoming_htlc_id, 14, proto3_optional: true, type: :uint64, json_name: "incomingHtlcId"
  field :outgoing_htlc_id, 15, proto3_optional: true, type: :uint64, json_name: "outgoingHtlcId"
end

defmodule Lightnex.LNRPC.Lightning.ForwardingHistoryResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :forwarding_events, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ForwardingEvent,
    json_name: "forwardingEvents"

  field :last_offset_index, 2, type: :uint32, json_name: "lastOffsetIndex"
end

defmodule Lightnex.LNRPC.Lightning.ExportChannelBackupRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_point, 1, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "chanPoint"
end

defmodule Lightnex.LNRPC.Lightning.ChannelBackup do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_point, 1, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "chanPoint"
  field :chan_backup, 2, type: :bytes, json_name: "chanBackup"
end

defmodule Lightnex.LNRPC.Lightning.MultiChanBackup do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_points, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ChannelPoint,
    json_name: "chanPoints"

  field :multi_chan_backup, 2, type: :bytes, json_name: "multiChanBackup"
end

defmodule Lightnex.LNRPC.Lightning.ChanBackupExportRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.ChanBackupSnapshot do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :single_chan_backups, 1,
    type: Lightnex.LNRPC.Lightning.ChannelBackups,
    json_name: "singleChanBackups"

  field :multi_chan_backup, 2,
    type: Lightnex.LNRPC.Lightning.MultiChanBackup,
    json_name: "multiChanBackup"
end

defmodule Lightnex.LNRPC.Lightning.ChannelBackups do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_backups, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ChannelBackup,
    json_name: "chanBackups"
end

defmodule Lightnex.LNRPC.Lightning.RestoreChanBackupRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :backup, 0

  field :chan_backups, 1,
    type: Lightnex.LNRPC.Lightning.ChannelBackups,
    json_name: "chanBackups",
    oneof: 0

  field :multi_chan_backup, 2, type: :bytes, json_name: "multiChanBackup", oneof: 0
end

defmodule Lightnex.LNRPC.Lightning.RestoreBackupResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :num_restored, 1, type: :uint32, json_name: "numRestored"
end

defmodule Lightnex.LNRPC.Lightning.ChannelBackupSubscription do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.VerifyChanBackupResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_points, 1, repeated: true, type: :string, json_name: "chanPoints"
end

defmodule Lightnex.LNRPC.Lightning.MacaroonPermission do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :entity, 1, type: :string
  field :action, 2, type: :string
end

defmodule Lightnex.LNRPC.Lightning.BakeMacaroonRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :permissions, 1, repeated: true, type: Lightnex.LNRPC.Lightning.MacaroonPermission
  field :root_key_id, 2, type: :uint64, json_name: "rootKeyId"
  field :allow_external_permissions, 3, type: :bool, json_name: "allowExternalPermissions"
end

defmodule Lightnex.LNRPC.Lightning.BakeMacaroonResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :macaroon, 1, type: :string
end

defmodule Lightnex.LNRPC.Lightning.ListMacaroonIDsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.ListMacaroonIDsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :root_key_ids, 1, repeated: true, type: :uint64, json_name: "rootKeyIds"
end

defmodule Lightnex.LNRPC.Lightning.DeleteMacaroonIDRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :root_key_id, 1, type: :uint64, json_name: "rootKeyId"
end

defmodule Lightnex.LNRPC.Lightning.DeleteMacaroonIDResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :deleted, 1, type: :bool
end

defmodule Lightnex.LNRPC.Lightning.MacaroonPermissionList do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :permissions, 1, repeated: true, type: Lightnex.LNRPC.Lightning.MacaroonPermission
end

defmodule Lightnex.LNRPC.Lightning.ListPermissionsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Lightning.ListPermissionsResponse.MethodPermissionsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Lightnex.LNRPC.Lightning.MacaroonPermissionList
end

defmodule Lightnex.LNRPC.Lightning.ListPermissionsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :method_permissions, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.ListPermissionsResponse.MethodPermissionsEntry,
    json_name: "methodPermissions",
    map: true
end

defmodule Lightnex.LNRPC.Lightning.Failure do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :code, 1, type: Lightnex.LNRPC.Lightning.Failure.FailureCode, enum: true

  field :channel_update, 3,
    type: Lightnex.LNRPC.Lightning.ChannelUpdate,
    json_name: "channelUpdate"

  field :htlc_msat, 4, type: :uint64, json_name: "htlcMsat"
  field :onion_sha_256, 5, type: :bytes, json_name: "onionSha256"
  field :cltv_expiry, 6, type: :uint32, json_name: "cltvExpiry"
  field :flags, 7, type: :uint32
  field :failure_source_index, 8, type: :uint32, json_name: "failureSourceIndex"
  field :height, 9, type: :uint32
end

defmodule Lightnex.LNRPC.Lightning.ChannelUpdate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :signature, 1, type: :bytes
  field :chain_hash, 2, type: :bytes, json_name: "chainHash"
  field :chan_id, 3, type: :uint64, json_name: "chanId", deprecated: false
  field :timestamp, 4, type: :uint32
  field :message_flags, 10, type: :uint32, json_name: "messageFlags"
  field :channel_flags, 5, type: :uint32, json_name: "channelFlags"
  field :time_lock_delta, 6, type: :uint32, json_name: "timeLockDelta"
  field :htlc_minimum_msat, 7, type: :uint64, json_name: "htlcMinimumMsat"
  field :base_fee, 8, type: :uint32, json_name: "baseFee"
  field :fee_rate, 9, type: :uint32, json_name: "feeRate"
  field :htlc_maximum_msat, 11, type: :uint64, json_name: "htlcMaximumMsat"
  field :extra_opaque_data, 12, type: :bytes, json_name: "extraOpaqueData"
end

defmodule Lightnex.LNRPC.Lightning.MacaroonId do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :nonce, 1, type: :bytes
  field :storageId, 2, type: :bytes
  field :ops, 3, repeated: true, type: Lightnex.LNRPC.Lightning.Op
end

defmodule Lightnex.LNRPC.Lightning.Op do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :entity, 1, type: :string
  field :actions, 2, repeated: true, type: :string
end

defmodule Lightnex.LNRPC.Lightning.CheckMacPermRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :macaroon, 1, type: :bytes
  field :permissions, 2, repeated: true, type: Lightnex.LNRPC.Lightning.MacaroonPermission
  field :fullMethod, 3, type: :string
end

defmodule Lightnex.LNRPC.Lightning.CheckMacPermResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :valid, 1, type: :bool
end

defmodule Lightnex.LNRPC.Lightning.RPCMiddlewareRequest.MetadataPairsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Lightnex.LNRPC.Lightning.MetadataValues
end

defmodule Lightnex.LNRPC.Lightning.RPCMiddlewareRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :intercept_type, 0

  field :request_id, 1, type: :uint64, json_name: "requestId"
  field :raw_macaroon, 2, type: :bytes, json_name: "rawMacaroon"
  field :custom_caveat_condition, 3, type: :string, json_name: "customCaveatCondition"

  field :stream_auth, 4,
    type: Lightnex.LNRPC.Lightning.StreamAuth,
    json_name: "streamAuth",
    oneof: 0

  field :request, 5, type: Lightnex.LNRPC.Lightning.RPCMessage, oneof: 0
  field :response, 6, type: Lightnex.LNRPC.Lightning.RPCMessage, oneof: 0
  field :reg_complete, 8, type: :bool, json_name: "regComplete", oneof: 0
  field :msg_id, 7, type: :uint64, json_name: "msgId"

  field :metadata_pairs, 9,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.RPCMiddlewareRequest.MetadataPairsEntry,
    json_name: "metadataPairs",
    map: true
end

defmodule Lightnex.LNRPC.Lightning.MetadataValues do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :values, 1, repeated: true, type: :string
end

defmodule Lightnex.LNRPC.Lightning.StreamAuth do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :method_full_uri, 1, type: :string, json_name: "methodFullUri"
end

defmodule Lightnex.LNRPC.Lightning.RPCMessage do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :method_full_uri, 1, type: :string, json_name: "methodFullUri"
  field :stream_rpc, 2, type: :bool, json_name: "streamRpc"
  field :type_name, 3, type: :string, json_name: "typeName"
  field :serialized, 4, type: :bytes
  field :is_error, 5, type: :bool, json_name: "isError"
end

defmodule Lightnex.LNRPC.Lightning.RPCMiddlewareResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :middleware_message, 0

  field :ref_msg_id, 1, type: :uint64, json_name: "refMsgId"
  field :register, 2, type: Lightnex.LNRPC.Lightning.MiddlewareRegistration, oneof: 0
  field :feedback, 3, type: Lightnex.LNRPC.Lightning.InterceptFeedback, oneof: 0
end

defmodule Lightnex.LNRPC.Lightning.MiddlewareRegistration do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :middleware_name, 1, type: :string, json_name: "middlewareName"
  field :custom_macaroon_caveat_name, 2, type: :string, json_name: "customMacaroonCaveatName"
  field :read_only_mode, 3, type: :bool, json_name: "readOnlyMode"
end

defmodule Lightnex.LNRPC.Lightning.InterceptFeedback do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :error, 1, type: :string
  field :replace_response, 2, type: :bool, json_name: "replaceResponse"
  field :replacement_serialized, 3, type: :bytes, json_name: "replacementSerialized"
end

defmodule Lightnex.LNRPC.Lightning.Service do
  @moduledoc """
  Lightning is the main RPC server of the daemon.
  Comments in this file will be directly parsed into the API
  Documentation as descriptions of the associated method, message, or field.
  These descriptions should go right above the definition of the object, and
  can be in either block or // comment format.

  An RPC method can be matched to an lncli command by placing a line in the
  beginning of the description in exactly the following format:
  lncli: `methodname`

  Failure to specify the exact name of the command will cause documentation
  generation to fail.

  More information on how exactly the gRPC documentation is generated from
  this proto file can be found here:
  https://github.com/lightninglabs/lightning-api
  """

  use GRPC.Service, name: "lnrpc.Lightning", protoc_gen_elixir_version: "0.15.0"

  rpc :WalletBalance,
      Lightnex.LNRPC.Lightning.WalletBalanceRequest,
      Lightnex.LNRPC.Lightning.WalletBalanceResponse

  rpc :ChannelBalance,
      Lightnex.LNRPC.Lightning.ChannelBalanceRequest,
      Lightnex.LNRPC.Lightning.ChannelBalanceResponse

  rpc :GetTransactions,
      Lightnex.LNRPC.Lightning.GetTransactionsRequest,
      Lightnex.LNRPC.Lightning.TransactionDetails

  rpc :EstimateFee,
      Lightnex.LNRPC.Lightning.EstimateFeeRequest,
      Lightnex.LNRPC.Lightning.EstimateFeeResponse

  rpc :SendCoins,
      Lightnex.LNRPC.Lightning.SendCoinsRequest,
      Lightnex.LNRPC.Lightning.SendCoinsResponse

  rpc :ListUnspent,
      Lightnex.LNRPC.Lightning.ListUnspentRequest,
      Lightnex.LNRPC.Lightning.ListUnspentResponse

  rpc :SubscribeTransactions,
      Lightnex.LNRPC.Lightning.GetTransactionsRequest,
      stream(Lightnex.LNRPC.Lightning.Transaction)

  rpc :SendMany,
      Lightnex.LNRPC.Lightning.SendManyRequest,
      Lightnex.LNRPC.Lightning.SendManyResponse

  rpc :NewAddress,
      Lightnex.LNRPC.Lightning.NewAddressRequest,
      Lightnex.LNRPC.Lightning.NewAddressResponse

  rpc :SignMessage,
      Lightnex.LNRPC.Lightning.SignMessageRequest,
      Lightnex.LNRPC.Lightning.SignMessageResponse

  rpc :VerifyMessage,
      Lightnex.LNRPC.Lightning.VerifyMessageRequest,
      Lightnex.LNRPC.Lightning.VerifyMessageResponse

  rpc :ConnectPeer,
      Lightnex.LNRPC.Lightning.ConnectPeerRequest,
      Lightnex.LNRPC.Lightning.ConnectPeerResponse

  rpc :DisconnectPeer,
      Lightnex.LNRPC.Lightning.DisconnectPeerRequest,
      Lightnex.LNRPC.Lightning.DisconnectPeerResponse

  rpc :ListPeers,
      Lightnex.LNRPC.Lightning.ListPeersRequest,
      Lightnex.LNRPC.Lightning.ListPeersResponse

  rpc :SubscribePeerEvents,
      Lightnex.LNRPC.Lightning.PeerEventSubscription,
      stream(Lightnex.LNRPC.Lightning.PeerEvent)

  rpc :GetInfo, Lightnex.LNRPC.Lightning.GetInfoRequest, Lightnex.LNRPC.Lightning.GetInfoResponse

  rpc :GetDebugInfo,
      Lightnex.LNRPC.Lightning.GetDebugInfoRequest,
      Lightnex.LNRPC.Lightning.GetDebugInfoResponse

  rpc :GetRecoveryInfo,
      Lightnex.LNRPC.Lightning.GetRecoveryInfoRequest,
      Lightnex.LNRPC.Lightning.GetRecoveryInfoResponse

  rpc :PendingChannels,
      Lightnex.LNRPC.Lightning.PendingChannelsRequest,
      Lightnex.LNRPC.Lightning.PendingChannelsResponse

  rpc :ListChannels,
      Lightnex.LNRPC.Lightning.ListChannelsRequest,
      Lightnex.LNRPC.Lightning.ListChannelsResponse

  rpc :SubscribeChannelEvents,
      Lightnex.LNRPC.Lightning.ChannelEventSubscription,
      stream(Lightnex.LNRPC.Lightning.ChannelEventUpdate)

  rpc :ClosedChannels,
      Lightnex.LNRPC.Lightning.ClosedChannelsRequest,
      Lightnex.LNRPC.Lightning.ClosedChannelsResponse

  rpc :OpenChannelSync,
      Lightnex.LNRPC.Lightning.OpenChannelRequest,
      Lightnex.LNRPC.Lightning.ChannelPoint

  rpc :OpenChannel,
      Lightnex.LNRPC.Lightning.OpenChannelRequest,
      stream(Lightnex.LNRPC.Lightning.OpenStatusUpdate)

  rpc :BatchOpenChannel,
      Lightnex.LNRPC.Lightning.BatchOpenChannelRequest,
      Lightnex.LNRPC.Lightning.BatchOpenChannelResponse

  rpc :FundingStateStep,
      Lightnex.LNRPC.Lightning.FundingTransitionMsg,
      Lightnex.LNRPC.Lightning.FundingStateStepResp

  rpc :ChannelAcceptor,
      stream(Lightnex.LNRPC.Lightning.ChannelAcceptResponse),
      stream(Lightnex.LNRPC.Lightning.ChannelAcceptRequest)

  rpc :CloseChannel,
      Lightnex.LNRPC.Lightning.CloseChannelRequest,
      stream(Lightnex.LNRPC.Lightning.CloseStatusUpdate)

  rpc :AbandonChannel,
      Lightnex.LNRPC.Lightning.AbandonChannelRequest,
      Lightnex.LNRPC.Lightning.AbandonChannelResponse

  rpc :SendPayment,
      stream(Lightnex.LNRPC.Lightning.SendRequest),
      stream(Lightnex.LNRPC.Lightning.SendResponse)

  rpc :SendPaymentSync,
      Lightnex.LNRPC.Lightning.SendRequest,
      Lightnex.LNRPC.Lightning.SendResponse

  rpc :SendToRoute,
      stream(Lightnex.LNRPC.Lightning.SendToRouteRequest),
      stream(Lightnex.LNRPC.Lightning.SendResponse)

  rpc :SendToRouteSync,
      Lightnex.LNRPC.Lightning.SendToRouteRequest,
      Lightnex.LNRPC.Lightning.SendResponse

  rpc :AddInvoice, Lightnex.LNRPC.Lightning.Invoice, Lightnex.LNRPC.Lightning.AddInvoiceResponse

  rpc :ListInvoices,
      Lightnex.LNRPC.Lightning.ListInvoiceRequest,
      Lightnex.LNRPC.Lightning.ListInvoiceResponse

  rpc :LookupInvoice, Lightnex.LNRPC.Lightning.PaymentHash, Lightnex.LNRPC.Lightning.Invoice

  rpc :SubscribeInvoices,
      Lightnex.LNRPC.Lightning.InvoiceSubscription,
      stream(Lightnex.LNRPC.Lightning.Invoice)

  rpc :DecodePayReq, Lightnex.LNRPC.Lightning.PayReqString, Lightnex.LNRPC.Lightning.PayReq

  rpc :ListPayments,
      Lightnex.LNRPC.Lightning.ListPaymentsRequest,
      Lightnex.LNRPC.Lightning.ListPaymentsResponse

  rpc :DeletePayment,
      Lightnex.LNRPC.Lightning.DeletePaymentRequest,
      Lightnex.LNRPC.Lightning.DeletePaymentResponse

  rpc :DeleteAllPayments,
      Lightnex.LNRPC.Lightning.DeleteAllPaymentsRequest,
      Lightnex.LNRPC.Lightning.DeleteAllPaymentsResponse

  rpc :DescribeGraph,
      Lightnex.LNRPC.Lightning.ChannelGraphRequest,
      Lightnex.LNRPC.Lightning.ChannelGraph

  rpc :GetNodeMetrics,
      Lightnex.LNRPC.Lightning.NodeMetricsRequest,
      Lightnex.LNRPC.Lightning.NodeMetricsResponse

  rpc :GetChanInfo, Lightnex.LNRPC.Lightning.ChanInfoRequest, Lightnex.LNRPC.Lightning.ChannelEdge

  rpc :GetNodeInfo, Lightnex.LNRPC.Lightning.NodeInfoRequest, Lightnex.LNRPC.Lightning.NodeInfo

  rpc :QueryRoutes,
      Lightnex.LNRPC.Lightning.QueryRoutesRequest,
      Lightnex.LNRPC.Lightning.QueryRoutesResponse

  rpc :GetNetworkInfo,
      Lightnex.LNRPC.Lightning.NetworkInfoRequest,
      Lightnex.LNRPC.Lightning.NetworkInfo

  rpc :StopDaemon, Lightnex.LNRPC.Lightning.StopRequest, Lightnex.LNRPC.Lightning.StopResponse

  rpc :SubscribeChannelGraph,
      Lightnex.LNRPC.Lightning.GraphTopologySubscription,
      stream(Lightnex.LNRPC.Lightning.GraphTopologyUpdate)

  rpc :DebugLevel,
      Lightnex.LNRPC.Lightning.DebugLevelRequest,
      Lightnex.LNRPC.Lightning.DebugLevelResponse

  rpc :FeeReport,
      Lightnex.LNRPC.Lightning.FeeReportRequest,
      Lightnex.LNRPC.Lightning.FeeReportResponse

  rpc :UpdateChannelPolicy,
      Lightnex.LNRPC.Lightning.PolicyUpdateRequest,
      Lightnex.LNRPC.Lightning.PolicyUpdateResponse

  rpc :ForwardingHistory,
      Lightnex.LNRPC.Lightning.ForwardingHistoryRequest,
      Lightnex.LNRPC.Lightning.ForwardingHistoryResponse

  rpc :ExportChannelBackup,
      Lightnex.LNRPC.Lightning.ExportChannelBackupRequest,
      Lightnex.LNRPC.Lightning.ChannelBackup

  rpc :ExportAllChannelBackups,
      Lightnex.LNRPC.Lightning.ChanBackupExportRequest,
      Lightnex.LNRPC.Lightning.ChanBackupSnapshot

  rpc :VerifyChanBackup,
      Lightnex.LNRPC.Lightning.ChanBackupSnapshot,
      Lightnex.LNRPC.Lightning.VerifyChanBackupResponse

  rpc :RestoreChannelBackups,
      Lightnex.LNRPC.Lightning.RestoreChanBackupRequest,
      Lightnex.LNRPC.Lightning.RestoreBackupResponse

  rpc :SubscribeChannelBackups,
      Lightnex.LNRPC.Lightning.ChannelBackupSubscription,
      stream(Lightnex.LNRPC.Lightning.ChanBackupSnapshot)

  rpc :BakeMacaroon,
      Lightnex.LNRPC.Lightning.BakeMacaroonRequest,
      Lightnex.LNRPC.Lightning.BakeMacaroonResponse

  rpc :ListMacaroonIDs,
      Lightnex.LNRPC.Lightning.ListMacaroonIDsRequest,
      Lightnex.LNRPC.Lightning.ListMacaroonIDsResponse

  rpc :DeleteMacaroonID,
      Lightnex.LNRPC.Lightning.DeleteMacaroonIDRequest,
      Lightnex.LNRPC.Lightning.DeleteMacaroonIDResponse

  rpc :ListPermissions,
      Lightnex.LNRPC.Lightning.ListPermissionsRequest,
      Lightnex.LNRPC.Lightning.ListPermissionsResponse

  rpc :CheckMacaroonPermissions,
      Lightnex.LNRPC.Lightning.CheckMacPermRequest,
      Lightnex.LNRPC.Lightning.CheckMacPermResponse

  rpc :RegisterRPCMiddleware,
      stream(Lightnex.LNRPC.Lightning.RPCMiddlewareResponse),
      stream(Lightnex.LNRPC.Lightning.RPCMiddlewareRequest)

  rpc :SendCustomMessage,
      Lightnex.LNRPC.Lightning.SendCustomMessageRequest,
      Lightnex.LNRPC.Lightning.SendCustomMessageResponse

  rpc :SubscribeCustomMessages,
      Lightnex.LNRPC.Lightning.SubscribeCustomMessagesRequest,
      stream(Lightnex.LNRPC.Lightning.CustomMessage)

  rpc :ListAliases,
      Lightnex.LNRPC.Lightning.ListAliasesRequest,
      Lightnex.LNRPC.Lightning.ListAliasesResponse

  rpc :LookupHtlcResolution,
      Lightnex.LNRPC.Lightning.LookupHtlcResolutionRequest,
      Lightnex.LNRPC.Lightning.LookupHtlcResolutionResponse
end

defmodule Lightnex.LNRPC.Lightning.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.Lightning.Service
end
