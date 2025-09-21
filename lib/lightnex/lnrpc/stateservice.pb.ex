defmodule Lightnex.LNRPC.State.WalletState do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :NON_EXISTING, 0
  field :LOCKED, 1
  field :UNLOCKED, 2
  field :RPC_ACTIVE, 3
  field :SERVER_ACTIVE, 4
  field :WAITING_TO_START, 255
end

defmodule Lightnex.LNRPC.State.SubscribeStateRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.State.SubscribeStateResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :state, 1, type: Lightnex.LNRPC.State.WalletState, enum: true
end

defmodule Lightnex.LNRPC.State.GetStateRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.State.GetStateResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :state, 1, type: Lightnex.LNRPC.State.WalletState, enum: true
end

defmodule Lightnex.LNRPC.State.State.Service do
  @moduledoc """
  State service is a always running service that exposes the current state of
  the wallet and RPC server.
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

  use GRPC.Service, name: "lnrpc.State", protoc_gen_elixir_version: "0.15.0"

  rpc :SubscribeState,
      Lightnex.LNRPC.State.SubscribeStateRequest,
      stream(Lightnex.LNRPC.State.SubscribeStateResponse)

  rpc :GetState, Lightnex.LNRPC.State.GetStateRequest, Lightnex.LNRPC.State.GetStateResponse
end

defmodule Lightnex.LNRPC.State.State.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.State.State.Service
end
