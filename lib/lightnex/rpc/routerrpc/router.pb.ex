defmodule Lightnex.RPC.Router.FailureDetail do
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

defmodule Lightnex.RPC.Router.PaymentState do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :IN_FLIGHT, 0
  field :SUCCEEDED, 1
  field :FAILED_TIMEOUT, 2
  field :FAILED_NO_ROUTE, 3
  field :FAILED_ERROR, 4
  field :FAILED_INCORRECT_PAYMENT_DETAILS, 5
  field :FAILED_INSUFFICIENT_BALANCE, 6
end

defmodule Lightnex.RPC.Router.ResolveHoldForwardAction do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :SETTLE, 0
  field :FAIL, 1
  field :RESUME, 2
  field :RESUME_MODIFIED, 3
end

defmodule Lightnex.RPC.Router.ChanStatusAction do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :ENABLE, 0
  field :DISABLE, 1
  field :AUTO, 2
end

defmodule Lightnex.RPC.Router.MissionControlConfig.ProbabilityModel do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :APRIORI, 0
  field :BIMODAL, 1
end

defmodule Lightnex.RPC.Router.HtlcEvent.EventType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN, 0
  field :SEND, 1
  field :RECEIVE, 2
  field :FORWARD, 3
end

defmodule Lightnex.RPC.Router.SendPaymentRequest.DestCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.RPC.Router.SendPaymentRequest.FirstHopCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.RPC.Router.SendPaymentRequest do
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
    type: Lightnex.RPC.Lightning.RouteHint,
    json_name: "routeHints"

  field :dest_custom_records, 11,
    repeated: true,
    type: Lightnex.RPC.Router.SendPaymentRequest.DestCustomRecordsEntry,
    json_name: "destCustomRecords",
    map: true

  field :amt_msat, 12, type: :int64, json_name: "amtMsat"
  field :fee_limit_msat, 13, type: :int64, json_name: "feeLimitMsat"
  field :last_hop_pubkey, 14, type: :bytes, json_name: "lastHopPubkey"
  field :allow_self_payment, 15, type: :bool, json_name: "allowSelfPayment"

  field :dest_features, 16,
    repeated: true,
    type: Lightnex.RPC.Lightning.FeatureBit,
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
    type: Lightnex.RPC.Router.SendPaymentRequest.FirstHopCustomRecordsEntry,
    json_name: "firstHopCustomRecords",
    map: true
end

defmodule Lightnex.RPC.Router.TrackPaymentRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash"
  field :no_inflight_updates, 2, type: :bool, json_name: "noInflightUpdates"
end

defmodule Lightnex.RPC.Router.TrackPaymentsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :no_inflight_updates, 1, type: :bool, json_name: "noInflightUpdates"
end

defmodule Lightnex.RPC.Router.RouteFeeRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :dest, 1, type: :bytes
  field :amt_sat, 2, type: :int64, json_name: "amtSat"
  field :payment_request, 3, type: :string, json_name: "paymentRequest"
  field :timeout, 4, type: :uint32
end

defmodule Lightnex.RPC.Router.RouteFeeResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :routing_fee_msat, 1, type: :int64, json_name: "routingFeeMsat"
  field :time_lock_delay, 2, type: :int64, json_name: "timeLockDelay"

  field :failure_reason, 5,
    type: Lightnex.RPC.Lightning.PaymentFailureReason,
    json_name: "failureReason",
    enum: true
end

defmodule Lightnex.RPC.Router.SendToRouteRequest.FirstHopCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.RPC.Router.SendToRouteRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash"
  field :route, 2, type: Lightnex.RPC.Lightning.Route
  field :skip_temp_err, 3, type: :bool, json_name: "skipTempErr"

  field :first_hop_custom_records, 4,
    repeated: true,
    type: Lightnex.RPC.Router.SendToRouteRequest.FirstHopCustomRecordsEntry,
    json_name: "firstHopCustomRecords",
    map: true
end

defmodule Lightnex.RPC.Router.SendToRouteResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :preimage, 1, type: :bytes
  field :failure, 2, type: Lightnex.RPC.Lightning.Failure
end

defmodule Lightnex.RPC.Router.ResetMissionControlRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.ResetMissionControlResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.QueryMissionControlRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.QueryMissionControlResponse do
  @moduledoc """
  QueryMissionControlResponse contains mission control state.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pairs, 2, repeated: true, type: Lightnex.RPC.Router.PairHistory
end

defmodule Lightnex.RPC.Router.XImportMissionControlRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pairs, 1, repeated: true, type: Lightnex.RPC.Router.PairHistory
  field :force, 2, type: :bool
end

defmodule Lightnex.RPC.Router.XImportMissionControlResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.PairHistory do
  @moduledoc """
  PairHistory contains the mission control state for a particular node pair.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_from, 1, type: :bytes, json_name: "nodeFrom"
  field :node_to, 2, type: :bytes, json_name: "nodeTo"
  field :history, 7, type: Lightnex.RPC.Router.PairData
end

defmodule Lightnex.RPC.Router.PairData do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :fail_time, 1, type: :int64, json_name: "failTime"
  field :fail_amt_sat, 2, type: :int64, json_name: "failAmtSat"
  field :fail_amt_msat, 4, type: :int64, json_name: "failAmtMsat"
  field :success_time, 5, type: :int64, json_name: "successTime"
  field :success_amt_sat, 6, type: :int64, json_name: "successAmtSat"
  field :success_amt_msat, 7, type: :int64, json_name: "successAmtMsat"
end

defmodule Lightnex.RPC.Router.GetMissionControlConfigRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.GetMissionControlConfigResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :config, 1, type: Lightnex.RPC.Router.MissionControlConfig
end

defmodule Lightnex.RPC.Router.SetMissionControlConfigRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :config, 1, type: Lightnex.RPC.Router.MissionControlConfig
end

defmodule Lightnex.RPC.Router.SetMissionControlConfigResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.MissionControlConfig do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :EstimatorConfig, 0

  field :half_life_seconds, 1, type: :uint64, json_name: "halfLifeSeconds", deprecated: true
  field :hop_probability, 2, type: :float, json_name: "hopProbability", deprecated: true
  field :weight, 3, type: :float, deprecated: true
  field :maximum_payment_results, 4, type: :uint32, json_name: "maximumPaymentResults"

  field :minimum_failure_relax_interval, 5,
    type: :uint64,
    json_name: "minimumFailureRelaxInterval"

  field :model, 6, type: Lightnex.RPC.Router.MissionControlConfig.ProbabilityModel, enum: true
  field :apriori, 7, type: Lightnex.RPC.Router.AprioriParameters, oneof: 0
  field :bimodal, 8, type: Lightnex.RPC.Router.BimodalParameters, oneof: 0
end

defmodule Lightnex.RPC.Router.BimodalParameters do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :node_weight, 1, type: :double, json_name: "nodeWeight"
  field :scale_msat, 2, type: :uint64, json_name: "scaleMsat"
  field :decay_time, 3, type: :uint64, json_name: "decayTime"
end

defmodule Lightnex.RPC.Router.AprioriParameters do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :half_life_seconds, 1, type: :uint64, json_name: "halfLifeSeconds"
  field :hop_probability, 2, type: :double, json_name: "hopProbability"
  field :weight, 3, type: :double
  field :capacity_fraction, 4, type: :double, json_name: "capacityFraction"
end

defmodule Lightnex.RPC.Router.QueryProbabilityRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :from_node, 1, type: :bytes, json_name: "fromNode"
  field :to_node, 2, type: :bytes, json_name: "toNode"
  field :amt_msat, 3, type: :int64, json_name: "amtMsat"
end

defmodule Lightnex.RPC.Router.QueryProbabilityResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :probability, 1, type: :double
  field :history, 2, type: Lightnex.RPC.Router.PairData
end

defmodule Lightnex.RPC.Router.BuildRouteRequest.FirstHopCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.RPC.Router.BuildRouteRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :amt_msat, 1, type: :int64, json_name: "amtMsat"
  field :final_cltv_delta, 2, type: :int32, json_name: "finalCltvDelta"
  field :outgoing_chan_id, 3, type: :uint64, json_name: "outgoingChanId", deprecated: false
  field :hop_pubkeys, 4, repeated: true, type: :bytes, json_name: "hopPubkeys"
  field :payment_addr, 5, type: :bytes, json_name: "paymentAddr"

  field :first_hop_custom_records, 6,
    repeated: true,
    type: Lightnex.RPC.Router.BuildRouteRequest.FirstHopCustomRecordsEntry,
    json_name: "firstHopCustomRecords",
    map: true
end

defmodule Lightnex.RPC.Router.BuildRouteResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :route, 1, type: Lightnex.RPC.Lightning.Route
end

defmodule Lightnex.RPC.Router.SubscribeHtlcEventsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.HtlcEvent do
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
    type: Lightnex.RPC.Router.HtlcEvent.EventType,
    json_name: "eventType",
    enum: true

  field :forward_event, 7,
    type: Lightnex.RPC.Router.ForwardEvent,
    json_name: "forwardEvent",
    oneof: 0

  field :forward_fail_event, 8,
    type: Lightnex.RPC.Router.ForwardFailEvent,
    json_name: "forwardFailEvent",
    oneof: 0

  field :settle_event, 9,
    type: Lightnex.RPC.Router.SettleEvent,
    json_name: "settleEvent",
    oneof: 0

  field :link_fail_event, 10,
    type: Lightnex.RPC.Router.LinkFailEvent,
    json_name: "linkFailEvent",
    oneof: 0

  field :subscribed_event, 11,
    type: Lightnex.RPC.Router.SubscribedEvent,
    json_name: "subscribedEvent",
    oneof: 0

  field :final_htlc_event, 12,
    type: Lightnex.RPC.Router.FinalHtlcEvent,
    json_name: "finalHtlcEvent",
    oneof: 0
end

defmodule Lightnex.RPC.Router.HtlcInfo do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :incoming_timelock, 1, type: :uint32, json_name: "incomingTimelock"
  field :outgoing_timelock, 2, type: :uint32, json_name: "outgoingTimelock"
  field :incoming_amt_msat, 3, type: :uint64, json_name: "incomingAmtMsat"
  field :outgoing_amt_msat, 4, type: :uint64, json_name: "outgoingAmtMsat"
end

defmodule Lightnex.RPC.Router.ForwardEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :info, 1, type: Lightnex.RPC.Router.HtlcInfo
end

defmodule Lightnex.RPC.Router.ForwardFailEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.SettleEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :preimage, 1, type: :bytes
end

defmodule Lightnex.RPC.Router.FinalHtlcEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :settled, 1, type: :bool
  field :offchain, 2, type: :bool
end

defmodule Lightnex.RPC.Router.SubscribedEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.LinkFailEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :info, 1, type: Lightnex.RPC.Router.HtlcInfo

  field :wire_failure, 2,
    type: Lightnex.RPC.Lightning.Failure.FailureCode,
    json_name: "wireFailure",
    enum: true

  field :failure_detail, 3,
    type: Lightnex.RPC.Router.FailureDetail,
    json_name: "failureDetail",
    enum: true

  field :failure_string, 4, type: :string, json_name: "failureString"
end

defmodule Lightnex.RPC.Router.PaymentStatus do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :state, 1, type: Lightnex.RPC.Router.PaymentState, enum: true
  field :preimage, 2, type: :bytes
  field :htlcs, 4, repeated: true, type: Lightnex.RPC.Lightning.HTLCAttempt
end

defmodule Lightnex.RPC.Router.CircuitKey do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId"
  field :htlc_id, 2, type: :uint64, json_name: "htlcId"
end

defmodule Lightnex.RPC.Router.ForwardHtlcInterceptRequest.CustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.RPC.Router.ForwardHtlcInterceptRequest.InWireCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.RPC.Router.ForwardHtlcInterceptRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :incoming_circuit_key, 1,
    type: Lightnex.RPC.Router.CircuitKey,
    json_name: "incomingCircuitKey"

  field :incoming_amount_msat, 5, type: :uint64, json_name: "incomingAmountMsat"
  field :incoming_expiry, 6, type: :uint32, json_name: "incomingExpiry"
  field :payment_hash, 2, type: :bytes, json_name: "paymentHash"
  field :outgoing_requested_chan_id, 7, type: :uint64, json_name: "outgoingRequestedChanId"
  field :outgoing_amount_msat, 3, type: :uint64, json_name: "outgoingAmountMsat"
  field :outgoing_expiry, 4, type: :uint32, json_name: "outgoingExpiry"

  field :custom_records, 8,
    repeated: true,
    type: Lightnex.RPC.Router.ForwardHtlcInterceptRequest.CustomRecordsEntry,
    json_name: "customRecords",
    map: true

  field :onion_blob, 9, type: :bytes, json_name: "onionBlob"
  field :auto_fail_height, 10, type: :int32, json_name: "autoFailHeight"

  field :in_wire_custom_records, 11,
    repeated: true,
    type: Lightnex.RPC.Router.ForwardHtlcInterceptRequest.InWireCustomRecordsEntry,
    json_name: "inWireCustomRecords",
    map: true
end

defmodule Lightnex.RPC.Router.ForwardHtlcInterceptResponse.OutWireCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.RPC.Router.ForwardHtlcInterceptResponse do
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
    type: Lightnex.RPC.Router.CircuitKey,
    json_name: "incomingCircuitKey"

  field :action, 2, type: Lightnex.RPC.Router.ResolveHoldForwardAction, enum: true
  field :preimage, 3, type: :bytes
  field :failure_message, 4, type: :bytes, json_name: "failureMessage"

  field :failure_code, 5,
    type: Lightnex.RPC.Lightning.Failure.FailureCode,
    json_name: "failureCode",
    enum: true

  field :in_amount_msat, 6, type: :uint64, json_name: "inAmountMsat"
  field :out_amount_msat, 7, type: :uint64, json_name: "outAmountMsat"

  field :out_wire_custom_records, 8,
    repeated: true,
    type: Lightnex.RPC.Router.ForwardHtlcInterceptResponse.OutWireCustomRecordsEntry,
    json_name: "outWireCustomRecords",
    map: true
end

defmodule Lightnex.RPC.Router.UpdateChanStatusRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_point, 1, type: Lightnex.RPC.Lightning.ChannelPoint, json_name: "chanPoint"
  field :action, 2, type: Lightnex.RPC.Router.ChanStatusAction, enum: true
end

defmodule Lightnex.RPC.Router.UpdateChanStatusResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.Router.AddAliasesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.RPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.RPC.Router.AddAliasesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.RPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.RPC.Router.DeleteAliasesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.RPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.RPC.Router.DeleteAliasesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :alias_maps, 1,
    repeated: true,
    type: Lightnex.RPC.Lightning.AliasMap,
    json_name: "aliasMaps"
end

defmodule Lightnex.RPC.Router.Service do
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
      Lightnex.RPC.Router.SendPaymentRequest,
      stream(Lightnex.RPC.Lightning.Payment)

  rpc :TrackPaymentV2,
      Lightnex.RPC.Router.TrackPaymentRequest,
      stream(Lightnex.RPC.Lightning.Payment)

  rpc :TrackPayments,
      Lightnex.RPC.Router.TrackPaymentsRequest,
      stream(Lightnex.RPC.Lightning.Payment)

  rpc :EstimateRouteFee, Lightnex.RPC.Router.RouteFeeRequest, Lightnex.RPC.Router.RouteFeeResponse

  rpc :SendToRoute,
      Lightnex.RPC.Router.SendToRouteRequest,
      Lightnex.RPC.Router.SendToRouteResponse

  rpc :SendToRouteV2, Lightnex.RPC.Router.SendToRouteRequest, Lightnex.RPC.Lightning.HTLCAttempt

  rpc :ResetMissionControl,
      Lightnex.RPC.Router.ResetMissionControlRequest,
      Lightnex.RPC.Router.ResetMissionControlResponse

  rpc :QueryMissionControl,
      Lightnex.RPC.Router.QueryMissionControlRequest,
      Lightnex.RPC.Router.QueryMissionControlResponse

  rpc :XImportMissionControl,
      Lightnex.RPC.Router.XImportMissionControlRequest,
      Lightnex.RPC.Router.XImportMissionControlResponse

  rpc :GetMissionControlConfig,
      Lightnex.RPC.Router.GetMissionControlConfigRequest,
      Lightnex.RPC.Router.GetMissionControlConfigResponse

  rpc :SetMissionControlConfig,
      Lightnex.RPC.Router.SetMissionControlConfigRequest,
      Lightnex.RPC.Router.SetMissionControlConfigResponse

  rpc :QueryProbability,
      Lightnex.RPC.Router.QueryProbabilityRequest,
      Lightnex.RPC.Router.QueryProbabilityResponse

  rpc :BuildRoute, Lightnex.RPC.Router.BuildRouteRequest, Lightnex.RPC.Router.BuildRouteResponse

  rpc :SubscribeHtlcEvents,
      Lightnex.RPC.Router.SubscribeHtlcEventsRequest,
      stream(Lightnex.RPC.Router.HtlcEvent)

  rpc :SendPayment,
      Lightnex.RPC.Router.SendPaymentRequest,
      stream(Lightnex.RPC.Router.PaymentStatus)

  rpc :TrackPayment,
      Lightnex.RPC.Router.TrackPaymentRequest,
      stream(Lightnex.RPC.Router.PaymentStatus)

  rpc :HtlcInterceptor,
      stream(Lightnex.RPC.Router.ForwardHtlcInterceptResponse),
      stream(Lightnex.RPC.Router.ForwardHtlcInterceptRequest)

  rpc :UpdateChanStatus,
      Lightnex.RPC.Router.UpdateChanStatusRequest,
      Lightnex.RPC.Router.UpdateChanStatusResponse

  rpc :XAddLocalChanAliases,
      Lightnex.RPC.Router.AddAliasesRequest,
      Lightnex.RPC.Router.AddAliasesResponse

  rpc :XDeleteLocalChanAliases,
      Lightnex.RPC.Router.DeleteAliasesRequest,
      Lightnex.RPC.Router.DeleteAliasesResponse
end

defmodule Lightnex.RPC.Router.Stub do
  use GRPC.Stub, service: Lightnex.RPC.Router.Service
end
