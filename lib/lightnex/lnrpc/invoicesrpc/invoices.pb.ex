defmodule Lightnex.LNRPC.Invoices.LookupModifier do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :DEFAULT, 0
  field :HTLC_SET_ONLY, 1
  field :HTLC_SET_BLANK, 2
end

defmodule Lightnex.LNRPC.Invoices.CancelInvoiceMsg do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash"
end

defmodule Lightnex.LNRPC.Invoices.CancelInvoiceResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Invoices.AddHoldInvoiceRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :memo, 1, type: :string
  field :hash, 2, type: :bytes
  field :value, 3, type: :int64
  field :value_msat, 10, type: :int64, json_name: "valueMsat"
  field :description_hash, 4, type: :bytes, json_name: "descriptionHash"
  field :expiry, 5, type: :int64
  field :fallback_addr, 6, type: :string, json_name: "fallbackAddr"
  field :cltv_expiry, 7, type: :uint64, json_name: "cltvExpiry"

  field :route_hints, 8,
    repeated: true,
    type: Lightnex.LNRPC.Lightning.RouteHint,
    json_name: "routeHints"

  field :private, 9, type: :bool
end

defmodule Lightnex.LNRPC.Invoices.AddHoldInvoiceResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :payment_request, 1, type: :string, json_name: "paymentRequest"
  field :add_index, 2, type: :uint64, json_name: "addIndex"
  field :payment_addr, 3, type: :bytes, json_name: "paymentAddr"
end

defmodule Lightnex.LNRPC.Invoices.SettleInvoiceMsg do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :preimage, 1, type: :bytes
end

defmodule Lightnex.LNRPC.Invoices.SettleInvoiceResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Invoices.SubscribeSingleInvoiceRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :r_hash, 2, type: :bytes, json_name: "rHash"
end

defmodule Lightnex.LNRPC.Invoices.LookupInvoiceMsg do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :invoice_ref, 0

  field :payment_hash, 1, type: :bytes, json_name: "paymentHash", oneof: 0
  field :payment_addr, 2, type: :bytes, json_name: "paymentAddr", oneof: 0
  field :set_id, 3, type: :bytes, json_name: "setId", oneof: 0

  field :lookup_modifier, 4,
    type: Lightnex.LNRPC.Invoices.LookupModifier,
    json_name: "lookupModifier",
    enum: true
end

defmodule Lightnex.LNRPC.Invoices.CircuitKey do
  @moduledoc """
  CircuitKey is a unique identifier for an HTLC.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_id, 1, type: :uint64, json_name: "chanId"
  field :htlc_id, 2, type: :uint64, json_name: "htlcId"
end

defmodule Lightnex.LNRPC.Invoices.HtlcModifyRequest.ExitHtlcWireCustomRecordsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :uint64
  field :value, 2, type: :bytes
end

defmodule Lightnex.LNRPC.Invoices.HtlcModifyRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :invoice, 1, type: Lightnex.LNRPC.Lightning.Invoice

  field :exit_htlc_circuit_key, 2,
    type: Lightnex.LNRPC.Invoices.CircuitKey,
    json_name: "exitHtlcCircuitKey"

  field :exit_htlc_amt, 3, type: :uint64, json_name: "exitHtlcAmt"
  field :exit_htlc_expiry, 4, type: :uint32, json_name: "exitHtlcExpiry"
  field :current_height, 5, type: :uint32, json_name: "currentHeight"

  field :exit_htlc_wire_custom_records, 6,
    repeated: true,
    type: Lightnex.LNRPC.Invoices.HtlcModifyRequest.ExitHtlcWireCustomRecordsEntry,
    json_name: "exitHtlcWireCustomRecords",
    map: true
end

defmodule Lightnex.LNRPC.Invoices.HtlcModifyResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :circuit_key, 1, type: Lightnex.LNRPC.Invoices.CircuitKey, json_name: "circuitKey"
  field :amt_paid, 2, proto3_optional: true, type: :uint64, json_name: "amtPaid"
  field :cancel_set, 3, type: :bool, json_name: "cancelSet"
end

defmodule Lightnex.LNRPC.Invoices.Service do
  @moduledoc """
  Invoices is a service that can be used to create, accept, settle and cancel
  invoices.
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

  use GRPC.Service, name: "invoicesrpc.Invoices", protoc_gen_elixir_version: "0.15.0"

  rpc :SubscribeSingleInvoice,
      Lightnex.LNRPC.Invoices.SubscribeSingleInvoiceRequest,
      stream(Lightnex.LNRPC.Lightning.Invoice)

  rpc :CancelInvoice,
      Lightnex.LNRPC.Invoices.CancelInvoiceMsg,
      Lightnex.LNRPC.Invoices.CancelInvoiceResp

  rpc :AddHoldInvoice,
      Lightnex.LNRPC.Invoices.AddHoldInvoiceRequest,
      Lightnex.LNRPC.Invoices.AddHoldInvoiceResp

  rpc :SettleInvoice,
      Lightnex.LNRPC.Invoices.SettleInvoiceMsg,
      Lightnex.LNRPC.Invoices.SettleInvoiceResp

  rpc :LookupInvoiceV2, Lightnex.LNRPC.Invoices.LookupInvoiceMsg, Lightnex.LNRPC.Lightning.Invoice

  rpc :HtlcModifier,
      stream(Lightnex.LNRPC.Invoices.HtlcModifyResponse),
      stream(Lightnex.LNRPC.Invoices.HtlcModifyRequest)
end

defmodule Lightnex.LNRPC.Invoices.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.Invoices.Service
end
