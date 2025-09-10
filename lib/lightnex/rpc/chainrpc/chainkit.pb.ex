defmodule Lightnex.RPC.ChainKit.GetBlockRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
end

defmodule Lightnex.RPC.ChainKit.GetBlockResponse do
  @moduledoc """
  TODO(ffranr): The neutrino GetBlock response includes many
  additional helpful fields. Consider adding them here also.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_block, 1, type: :bytes, json_name: "rawBlock"
end

defmodule Lightnex.RPC.ChainKit.GetBlockHeaderRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
end

defmodule Lightnex.RPC.ChainKit.GetBlockHeaderResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_block_header, 1, type: :bytes, json_name: "rawBlockHeader"
end

defmodule Lightnex.RPC.ChainKit.GetBestBlockRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.ChainKit.GetBestBlockResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
  field :block_height, 2, type: :int32, json_name: "blockHeight"
end

defmodule Lightnex.RPC.ChainKit.GetBlockHashRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_height, 1, type: :int64, json_name: "blockHeight"
end

defmodule Lightnex.RPC.ChainKit.GetBlockHashResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
end

defmodule Lightnex.RPC.ChainKit.Service do
  @moduledoc """
  ChainKit is a service that can be used to get information from the
  chain backend.
  """

  use GRPC.Service, name: "chainrpc.ChainKit", protoc_gen_elixir_version: "0.15.0"

  rpc :GetBlock, Lightnex.RPC.ChainKit.GetBlockRequest, Lightnex.RPC.ChainKit.GetBlockResponse

  rpc :GetBlockHeader,
      Lightnex.RPC.ChainKit.GetBlockHeaderRequest,
      Lightnex.RPC.ChainKit.GetBlockHeaderResponse

  rpc :GetBestBlock,
      Lightnex.RPC.ChainKit.GetBestBlockRequest,
      Lightnex.RPC.ChainKit.GetBestBlockResponse

  rpc :GetBlockHash,
      Lightnex.RPC.ChainKit.GetBlockHashRequest,
      Lightnex.RPC.ChainKit.GetBlockHashResponse
end

defmodule Lightnex.RPC.ChainKit.Stub do
  use GRPC.Stub, service: Lightnex.RPC.ChainKit.Service
end
