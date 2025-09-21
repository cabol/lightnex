defmodule Lightnex.LNRPC.Router.FailureDetail do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN, 0
  field :NO_DETAIL, 1
  field :ONION_DECODE, 2
  field :LINK_NOT_ELIGIBLE, 3
  field :ON_CHAIN_TIMEOUT, 4
  field :HTLC_EXCEEDS_MAX, 5
  field :INSUFFICIENT_BALANCE, 6
  field :INCOMPLETE_FORWARD, 7
  field :HTLC_ADD_FAILED, 8
  field :FORWARDS_DISABLED, 9
  field :INVOICE_CANCELED, 10
  field :INVOICE_UNDERPAID, 11
  field :INVOICE_EXPIRY_TOO_SOON, 12
  field :INVOICE_NOT_OPEN, 13
  field :MPP_INVOICE_TIMEOUT, 14
  field :ADDRESS_MISMATCH, 15
  field :SET_TOTAL_MISMATCH, 16
  field :SET_TOTAL_TOO_LOW, 17
  field :SET_OVERPAID, 18
  field :UNKNOWN_INVOICE, 19
  field :INVALID_KEYSEND, 20
  field :MPP_IN_PROGRESS, 21
  field :CIRCULAR_ROUTE, 22
end

defmodule Lightnex.LNRPC.Router.PaymentState do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :IN_FLIGHT, 0
  field :SUCCEEDED, 1
  field :FAILED_TIMEOUT, 2
  field :FAILED_NO_ROUTE, 3
  field :FAILED_ERROR, 4
  field :FAILED_INCORRECT_PAYMENT_DETAILS, 5
  field :FAILED_INSUFFICIENT_BALANCE, 6
end

defmodule Lightnex.LNRPC.Router.ResolveHoldForwardAction do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :SETTLE, 0
  field :FAIL, 1
  field :RESUME, 2
  field :RESUME_MODIFIED, 3
end

defmodule Lightnex.LNRPC.Router.ChanStatusAction do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :ENABLE, 0
  field :DISABLE, 1
  field :AUTO, 2
end

defmodule Lightnex.LNRPC.Router.MissionControlConfig.ProbabilityModel do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :APRIORI, 0
  field :BIMODAL, 1
end

defmodule Lightnex.LNRPC.Router.HtlcEvent.EventType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN, 0
  field :SEND, 1
  field :RECEIVE, 2
  field :FORWARD, 3
end

defmodule Lightnex.LNRPC.Router.SendPaymentRequest.DestCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Router.SendPaymentRequest.FirstHopCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Router.SendPaymentRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :dest, 1, type: :bytes
  field :amt, 2, type: :int64
  field :payment_hash, 3, type: :bytes, json_name: "paymentHash"
  field :final_cltv_delta, 4, type: :int32, json_name: "finalCltvDelta"
  field :payment_request, 5, type: :string, json_name: "paymentRequest"
  field :timeout_seconds, 6, type: :int32, json_name: "timeoutSeconds"
  field :fee_limit_sat, 7, type: :int64, json_name: "feeLimitSat"
  field :outgoing_chan_id, 8, type: :uint64, json_name: "outgoingChanId", deprecated: true
  field :cltv_limit, 9, type: :int32, json_name: "cltvLimit"

  field :route_hints, 10,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.RouteHint,
    json_name: "routeHints"

  field :dest_custom_records, 11,
    repeated: true,
    type: Lightnex.LNRPC.Router.SendPaymentRequest.DestCustomRecordsEntry,
    json_name: "destCustomRecords",
    map: true

  field :amt_msat, 12, type: :int64, json_name: "amtMsat"
  field :fee_limit_msat, 13, type: :int64, json_name: "feeLimitMsat"
  field :last_hop_pubkey, 14, type: :bytes, json_name: "lastHopPubkey"
  field :allow_self_payment, 15, type: :bool, json_name: "allowSelfPayment"

  field :dest_features, 16,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.FeatureBit,
    json_name: "destFeatures",
    enum: true

  field :max_parts, 17, type: :uint32, json_name: "maxParts"
  field :no_inflight_updates, 18, type: :bool, json_name: "noInflightUpdates"
  field :outgoing_chan_ids, 19, repeated: true, type: :uint64, json_name: "outgoingChanIds"
  field :payment_addr, 20, type: :bytes, json_name: "paymentAddr"
  field :max_shard_size_msat, 21, type: :uint64, json_name: "maxShardSizeMsat"
  field :amp, 22, type: :bool
  field :time_pref, 23, type: :double, json_name: "timePref"
  field :cancelable, 24, type: :bool

  field :first_hop_custom_records, 25,
    repeated: true,
    type: Lightnex.LNRPC.Router.SendPaymentRequest.FirstHopCustomRecordsEntry,
    json_name: "firstHopCustomRecords",
    map: true
end

defmodule Lightnex.LNRPC.Router.TrackPaymentRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash"
  field :no_inflight_updates, 2, type: :bool, json_name: "noInflightUpdates"
end

defmodule Lightnex.LNRPC.Router.TrackPaymentsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :no_inflight_updates, 1, type: :bool, json_name: "noInflightUpdates"
end

defmodule Lightnex.LNRPC.Router.RouteFeeRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :dest, 1, type: :bytes
  field :amt_sat, 2, type: :int64, json_name: "amtSat"
  field :payment_request, 3, type: :string, json_name: "paymentRequest"
  field :timeout, 4, type: :uint32
end

defmodule Lightnex.LNRPC.Router.RouteFeeResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :routing_fee_msat, 1, type: :int64, json_name: "routingFeeMsat"
  field :time_lock_delay, 2, type: :int64, json_name: "timeLockDelay"

  field :failure_reason, 5,
    type: Lightnex.LNRPC.Lightning.PaymentFailureReason,
    json_name: "failureReason",
    enum: true
end

defmodule Lightnex.LNRPC.Router.SendToRouteRequest.FirstHopCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Router.SendToRouteRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash"
  field :route, 2, type: Lightnex.LNRPC.Lightning.Route
  field :skip_temp_err, 3, type: :bool, json_name: "skipTempErr"

  field :first_hop_custom_records, 4,
    repeated: true,
    type: Lightnex.LNRPC.Router.SendToRouteRequest.FirstHopCustomRecordsEntry,
    json_name: "firstHopCustomRecords",
    map: true
end

defmodule Lightnex.LNRPC.Router.SendToRouteResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :preimage, 1, type: :bytes
  field :failure, 2, type: Lightnex.LNRPC.Lightning.Failure
end

defmodule Lightnex.LNRPC.Router.ResetMissionControlRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.ResetMissionControlResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.QueryMissionControlRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.QueryMissionControlResponse do
  @moduledoc """
  QueryMissionControlResponse contains mission control state.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pairs, 2, repeated: true, type: Lightnex.LNRPC.Router.PairHistory
end

defmodule Lightnex.LNRPC.Router.XImportMissionControlRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pairs, 1, repeated: true, type: Lightnex.LNRPC.Router.PairHistory
  field :force, 2, type: :bool
end

defmodule Lightnex.LNRPC.Router.XImportMissionControlResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.PairHistory do
  @moduledoc """
  PairHistory contains the mission control state for a particular node pair.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_from, 1, type: :bytes, json_name: "nodeFrom"
  field :node_to, 2, type: :bytes, json_name: "nodeTo"
  field :history, 7, type: Lightnex.LNRPC.Router.PairData
end

defmodule Lightnex.LNRPC.Router.PairData do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :fail_time, 1, type: :int64, json_name: "failTime"
  field :fail_amt_sat, 2, type: :int64, json_name: "failAmtSat"
  field :fail_amt_msat, 4, type: :int64, json_name: "failAmtMsat"
  field :success_time, 5, type: :int64, json_name: "successTime"
  field :success_amt_sat, 6, type: :int64, json_name: "successAmtSat"
  field :success_amt_msat, 7, type: :int64, json_name: "successAmtMsat"
end

defmodule Lightnex.LNRPC.Router.GetMissionControlConfigRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.GetMissionControlConfigResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :config, 1, type: Lightnex.LNRPC.Router.MissionControlConfig
end

defmodule Lightnex.LNRPC.Router.SetMissionControlConfigRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :config, 1, type: Lightnex.LNRPC.Router.MissionControlConfig
end

defmodule Lightnex.LNRPC.Router.SetMissionControlConfigResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.MissionControlConfig do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :EstimatorConfig, 0

  field :half_life_seconds, 1, type: :uint64, json_name: "halfLifeSeconds", deprecated: true
  field :hop_probability, 2, type: :float, json_name: "hopProbability", deprecated: true
  field :weight, 3, type: :float, deprecated: true
  field :maximum_payment_results, 4, type: :uint32, json_name: "maximumPaymentResults"

  field :minimum_failure_relax_interval, 5,
    type: :uint64,
    json_name: "minimumFailureRelaxInterval"

  field :model, 6, type: Lightnex.LNRPC.Router.MissionControlConfig.ProbabilityModel, enum: true
  field :apriori, 7, type: Lightnex.LNRPC.Router.AprioriParameters, oneof: 0
  field :bimodal, 8, type: Lightnex.LNRPC.Router.BimodalParameters, oneof: 0
end

defmodule Lightnex.LNRPC.Router.BimodalParameters do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_weight, 1, type: :double, json_name: "nodeWeight"
  field :scale_msat, 2, type: :uint64, json_name: "scaleMsat"
  field :decay_time, 3, type: :uint64, json_name: "decayTime"
end

defmodule Lightnex.LNRPC.Router.AprioriParameters do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :half_life_seconds, 1, type: :uint64, json_name: "halfLifeSeconds"
  field :hop_probability, 2, type: :double, json_name: "hopProbability"
  field :weight, 3, type: :double
  field :capacity_fraction, 4, type: :double, json_name: "capacityFraction"
end

defmodule Lightnex.LNRPC.Router.QueryProbabilityRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_node, 1, type: :bytes, json_name: "fromNode"
  field :to_node, 2, type: :bytes, json_name: "toNode"
  field :amt_msat, 3, type: :int64, json_name: "amtMsat"
end

defmodule Lightnex.LNRPC.Router.QueryProbabilityResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :probability, 1, type: :double
  field :history, 2, type: Lightnex.LNRPC.Router.PairData
end

defmodule Lightnex.LNRPC.Router.BuildRouteRequest.FirstHopCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Router.BuildRouteRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amt_msat, 1, type: :int64, json_name: "amtMsat"
  field :final_cltv_delta, 2, type: :int32, json_name: "finalCltvDelta"
  field :outgoing_chan_id, 3, type: :uint64, json_name: "outgoingChanId", deprecated: false
  field :hop_pubkeys, 4, repeated: true, type: :bytes, json_name: "hopPubkeys"
  field :payment_addr, 5, type: :bytes, json_name: "paymentAddr"

  field :first_hop_custom_records, 6,
    repeated: true,
    type: Lightnex.LNRPC.Router.BuildRouteRequest.FirstHopCustomRecordsEntry,
    json_name: "firstHopCustomRecords",
    map: true
end

defmodule Lightnex.LNRPC.Router.BuildRouteResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :route, 1, type: Lightnex.LNRPC.Lightning.Route
end

defmodule Lightnex.LNRPC.Router.SubscribeHtlcEventsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.HtlcEvent do
  @moduledoc """
  HtlcEvent contains the htlc event that was processed. These are served on a
  best-effort basis; events are not persisted, delivery is not guaranteed
  (in the event of a crash in the switch, forward events may be lost) and
  some events may be replayed upon restart. Events consumed from this package
  should be de-duplicated by the htlc's unique combination of incoming and
  outgoing channel id and htlc id. [EXPERIMENTAL]
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :event, 0

  field :incoming_channel_id, 1, type: :uint64, json_name: "incomingChannelId"
  field :outgoing_channel_id, 2, type: :uint64, json_name: "outgoingChannelId"
  field :incoming_htlc_id, 3, type: :uint64, json_name: "incomingHtlcId"
  field :outgoing_htlc_id, 4, type: :uint64, json_name: "outgoingHtlcId"
  field :timestamp_ns, 5, type: :uint64, json_name: "timestampNs"

  field :event_type, 6,
    type: Lightnex.LNRPC.Router.HtlcEvent.EventType,
    json_name: "eventType",
    enum: true

  field :forward_event, 7,
    type: Lightnex.LNRPC.Router.ForwardEvent,
    json_name: "forwardEvent",
    oneof: 0

  field :forward_fail_event, 8,
    type: Lightnex.LNRPC.Router.ForwardFailEvent,
    json_name: "forwardFailEvent",
    oneof: 0

  field :settle_event, 9,
    type: Lightnex.LNRPC.Router.SettleEvent,
    json_name: "settleEvent",
    oneof: 0

  field :link_fail_event, 10,
    type: Lightnex.LNRPC.Router.LinkFailEvent,
    json_name: "linkFailEvent",
    oneof: 0

  field :subscribed_event, 11,
    type: Lightnex.LNRPC.Router.SubscribedEvent,
    json_name: "subscribedEvent",
    oneof: 0

  field :final_htlc_event, 12,
    type: Lightnex.LNRPC.Router.FinalHtlcEvent,
    json_name: "finalHtlcEvent",
    oneof: 0
end

defmodule Lightnex.LNRPC.Router.HtlcInfo do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :incoming_timelock, 1, type: :uint32, json_name: "incomingTimelock"
  field :outgoing_timelock, 2, type: :uint32, json_name: "outgoingTimelock"
  field :incoming_amt_msat, 3, type: :uint64, json_name: "incomingAmtMsat"
  field :outgoing_amt_msat, 4, type: :uint64, json_name: "outgoingAmtMsat"
end

defmodule Lightnex.LNRPC.Router.ForwardEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :info, 1, type: Lightnex.LNRPC.Router.HtlcInfo
end

defmodule Lightnex.LNRPC.Router.ForwardFailEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.SettleEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :preimage, 1, type: :bytes
end

defmodule Lightnex.LNRPC.Router.FinalHtlcEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :settled, 1, type: :bool
  field :offchain, 2, type: :bool
end

defmodule Lightnex.LNRPC.Router.SubscribedEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.LinkFailEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :info, 1, type: Lightnex.LNRPC.Router.HtlcInfo

  field :wire_failure, 2,
    type: Lightnex.LNRPC.Lightning.Failure.FailureCode,
    json_name: "wireFailure",
    enum: true

  field :failure_detail, 3,
    type: Lightnex.LNRPC.Router.FailureDetail,
    json_name: "failureDetail",
    enum: true

  field :failure_string, 4, type: :string, json_name: "failureString"
end

defmodule Lightnex.LNRPC.Router.PaymentStatus do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :state, 1, type: Lightnex.LNRPC.Router.PaymentState, enum: true
  field :preimage, 2, type: :bytes
  field :htlcs, 4, repeated: true, type: Lightnex.LNRPC.Lightning.HTLCAttempt
end

defmodule Lightnex.LNRPC.Router.CircuitKey do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId"
  field :htlc_id, 2, type: :uint64, json_name: "htlcId"
end

defmodule Lightnex.LNRPC.Router.ForwardHtlcInterceptRequest.CustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Router.ForwardHtlcInterceptRequest.InWireCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Router.ForwardHtlcInterceptRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :incoming_circuit_key, 1,
    type: Lightnex.LNRPC.Router.CircuitKey,
    json_name: "incomingCircuitKey"

  field :incoming_amount_msat, 5, type: :uint64, json_name: "incomingAmountMsat"
  field :incoming_expiry, 6, type: :uint32, json_name: "incomingExpiry"
  field :payment_hash, 2, type: :bytes, json_name: "paymentHash"
  field :outgoing_requested_chan_id, 7, type: :uint64, json_name: "outgoingRequestedChanId"
  field :outgoing_amount_msat, 3, type: :uint64, json_name: "outgoingAmountMsat"
  field :outgoing_expiry, 4, type: :uint32, json_name: "outgoingExpiry"

  field :custom_records, 8,
    repeated: true,
    type: Lightnex.LNRPC.Router.ForwardHtlcInterceptRequest.CustomRecordsEntry,
    json_name: "customRecords",
    map: true

  field :onion_blob, 9, type: :bytes, json_name: "onionBlob"
  field :auto_fail_height, 10, type: :int32, json_name: "autoFailHeight"

  field :in_wire_custom_records, 11,
    repeated: true,
    type: Lightnex.LNRPC.Router.ForwardHtlcInterceptRequest.InWireCustomRecordsEntry,
    json_name: "inWireCustomRecords",
    map: true
end

defmodule Lightnex.LNRPC.Router.ForwardHtlcInterceptResponse.OutWireCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Router.ForwardHtlcInterceptResponse do
  @moduledoc """
  *
  ForwardHtlcInterceptResponse enables the caller to resolve a previously hold
  forward. The caller can choose either to:
  - `Resume`: Execute the default behavior (usually forward).
  - `ResumeModified`: Execute the default behavior (usually forward) with HTLC
  field modifications.
  - `Reject`: Fail the htlc backwards.
  - `Settle`: Settle this htlc with a given preimage.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :incoming_circuit_key, 1,
    type: Lightnex.LNRPC.Router.CircuitKey,
    json_name: "incomingCircuitKey"

  field :action, 2, type: Lightnex.LNRPC.Router.ResolveHoldForwardAction, enum: true
  field :preimage, 3, type: :bytes
  field :failure_message, 4, type: :bytes, json_name: "failureMessage"

  field :failure_code, 5,
    type: Lightnex.LNRPC.Lightning.Failure.FailureCode,
    json_name: "failureCode",
    enum: true

  field :in_amount_msat, 6, type: :uint64, json_name: "inAmountMsat"
  field :out_amount_msat, 7, type: :uint64, json_name: "outAmountMsat"

  field :out_wire_custom_records, 8,
    repeated: true,
    type: Lightnex.LNRPC.Router.ForwardHtlcInterceptResponse.OutWireCustomRecordsEntry,
    json_name: "outWireCustomRecords",
    map: true
end

defmodule Lightnex.LNRPC.Router.UpdateChanStatusRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_point, 1, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "chanPoint"
  field :action, 2, type: Lightnex.LNRPC.Router.ChanStatusAction, enum: true
end

defmodule Lightnex.LNRPC.Router.UpdateChanStatusResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Router.AddAliasesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.LNRPC.Router.AddAliasesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.LNRPC.Router.DeleteAliasesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.LNRPC.Router.DeleteAliasesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.LNRPC.Router.Service do
  @moduledoc """
  Router is a service that offers advanced interaction with the router
  subsystem of the daemon.
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

  use GRPC.Service, name: "routerrpc.Router", protoc_gen_elixir_version: "0.15.0"

  rpc :SendPaymentV2,
      Lightnex.LNRPC.Router.SendPaymentRequest,
      stream(Lightnex.LNRPC.Lightning.Payment)

  rpc :TrackPaymentV2,
      Lightnex.LNRPC.Router.TrackPaymentRequest,
      stream(Lightnex.LNRPC.Lightning.Payment)

  rpc :TrackPayments,
      Lightnex.LNRPC.Router.TrackPaymentsRequest,
      stream(Lightnex.LNRPC.Lightning.Payment)

  rpc :EstimateRouteFee,
      Lightnex.LNRPC.Router.RouteFeeRequest,
      Lightnex.LNRPC.Router.RouteFeeResponse

  rpc :SendToRoute,
      Lightnex.LNRPC.Router.SendToRouteRequest,
      Lightnex.LNRPC.Router.SendToRouteResponse

  rpc :SendToRouteV2,
      Lightnex.LNRPC.Router.SendToRouteRequest,
      Lightnex.LNRPC.Lightning.HTLCAttempt

  rpc :ResetMissionControl,
      Lightnex.LNRPC.Router.ResetMissionControlRequest,
      Lightnex.LNRPC.Router.ResetMissionControlResponse

  rpc :QueryMissionControl,
      Lightnex.LNRPC.Router.QueryMissionControlRequest,
      Lightnex.LNRPC.Router.QueryMissionControlResponse

  rpc :XImportMissionControl,
      Lightnex.LNRPC.Router.XImportMissionControlRequest,
      Lightnex.LNRPC.Router.XImportMissionControlResponse

  rpc :GetMissionControlConfig,
      Lightnex.LNRPC.Router.GetMissionControlConfigRequest,
      Lightnex.LNRPC.Router.GetMissionControlConfigResponse

  rpc :SetMissionControlConfig,
      Lightnex.LNRPC.Router.SetMissionControlConfigRequest,
      Lightnex.LNRPC.Router.SetMissionControlConfigResponse

  rpc :QueryProbability,
      Lightnex.LNRPC.Router.QueryProbabilityRequest,
      Lightnex.LNRPC.Router.QueryProbabilityResponse

  rpc :BuildRoute,
      Lightnex.LNRPC.Router.BuildRouteRequest,
      Lightnex.LNRPC.Router.BuildRouteResponse

  rpc :SubscribeHtlcEvents,
      Lightnex.LNRPC.Router.SubscribeHtlcEventsRequest,
      stream(Lightnex.LNRPC.Router.HtlcEvent)

  rpc :SendPayment,
      Lightnex.LNRPC.Router.SendPaymentRequest,
      stream(Lightnex.LNRPC.Router.PaymentStatus)

  rpc :TrackPayment,
      Lightnex.LNRPC.Router.TrackPaymentRequest,
      stream(Lightnex.LNRPC.Router.PaymentStatus)

  rpc :HtlcInterceptor,
      stream(Lightnex.LNRPC.Router.ForwardHtlcInterceptResponse),
      stream(Lightnex.LNRPC.Router.ForwardHtlcInterceptRequest)

  rpc :UpdateChanStatus,
      Lightnex.LNRPC.Router.UpdateChanStatusRequest,
      Lightnex.LNRPC.Router.UpdateChanStatusResponse

  rpc :XAddLocalChanAliases,
      Lightnex.LNRPC.Router.AddAliasesRequest,
      Lightnex.LNRPC.Router.AddAliasesResponse

  rpc :XDeleteLocalChanAliases,
      Lightnex.LNRPC.Router.DeleteAliasesRequest,
      Lightnex.LNRPC.Router.DeleteAliasesResponse
end

defmodule Lightnex.LNRPC.Router.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.Router.Service
end
