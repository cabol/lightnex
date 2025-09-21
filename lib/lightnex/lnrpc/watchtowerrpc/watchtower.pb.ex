defmodule Lightnex.LNRPC.Watchtower.GetInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Watchtower.GetInfoResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pubkey, 1, type: :bytes
  field :listeners, 2, repeated: true, type: :string
  field :uris, 3, repeated: true, type: :string
end

defmodule Lightnex.LNRPC.Watchtower.Service do
  @moduledoc """
  Watchtower is a service that grants access to the watchtower server
  functionality of the daemon.
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

  use GRPC.Service, name: "watchtowerrpc.Watchtower", protoc_gen_elixir_version: "0.15.0"

  rpc :GetInfo,
      Lightnex.LNRPC.Watchtower.GetInfoRequest,
      Lightnex.LNRPC.Watchtower.GetInfoResponse
end

defmodule Lightnex.LNRPC.Watchtower.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.Watchtower.Service
end
