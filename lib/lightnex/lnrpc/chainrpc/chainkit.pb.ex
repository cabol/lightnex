defmodule Lightnex.LNRPC.ChainKit.GetBlockRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
end

defmodule Lightnex.LNRPC.ChainKit.GetBlockResponse do
  @moduledoc """
  TODO(ffranr): The neutrino GetBlock response includes many
  additional helpful fields. Consider adding them here also.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_block, 1, type: :bytes, json_name: "rawBlock"
end

defmodule Lightnex.LNRPC.ChainKit.GetBlockHeaderRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
end

defmodule Lightnex.LNRPC.ChainKit.GetBlockHeaderResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_block_header, 1, type: :bytes, json_name: "rawBlockHeader"
end

defmodule Lightnex.LNRPC.ChainKit.GetBestBlockRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.ChainKit.GetBestBlockResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
  field :block_height, 2, type: :int32, json_name: "blockHeight"
end

defmodule Lightnex.LNRPC.ChainKit.GetBlockHashRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_height, 1, type: :int64, json_name: "blockHeight"
end

defmodule Lightnex.LNRPC.ChainKit.GetBlockHashResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :block_hash, 1, type: :bytes, json_name: "blockHash"
end

defmodule Lightnex.LNRPC.ChainKit.Service do
  @moduledoc """
  ChainKit is a service that can be used to get information from the
  chain backend.
  """

  use GRPC.Service, name: "chainrpc.ChainKit", protoc_gen_elixir_version: "0.15.0"

  rpc :GetBlock, Lightnex.LNRPC.ChainKit.GetBlockRequest, Lightnex.LNRPC.ChainKit.GetBlockResponse

  rpc :GetBlockHeader,
      Lightnex.LNRPC.ChainKit.GetBlockHeaderRequest,
      Lightnex.LNRPC.ChainKit.GetBlockHeaderResponse

  rpc :GetBestBlock,
      Lightnex.LNRPC.ChainKit.GetBestBlockRequest,
      Lightnex.LNRPC.ChainKit.GetBestBlockResponse

  rpc :GetBlockHash,
      Lightnex.LNRPC.ChainKit.GetBlockHashRequest,
      Lightnex.LNRPC.ChainKit.GetBlockHashResponse
end

defmodule Lightnex.LNRPC.ChainKit.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.ChainKit.Service
end
