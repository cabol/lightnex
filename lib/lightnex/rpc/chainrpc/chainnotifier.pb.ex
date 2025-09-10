defmodule Lightnex.RPC.ChainNotifier.ConfRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid, 1, type: :bytes
  field :script, 2, type: :bytes
  field :num_confs, 3, type: :uint32, json_name: "numConfs"
  field :height_hint, 4, type: :uint32, json_name: "heightHint"
  field :include_block, 5, type: :bool, json_name: "includeBlock"
end

defmodule Lightnex.RPC.ChainNotifier.ConfDetails do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_tx, 1, type: :bytes, json_name: "rawTx"
  field :block_hash, 2, type: :bytes, json_name: "blockHash"
  field :block_height, 3, type: :uint32, json_name: "blockHeight"
  field :tx_index, 4, type: :uint32, json_name: "txIndex"
  field :raw_block, 5, type: :bytes, json_name: "rawBlock"
end

defmodule Lightnex.RPC.ChainNotifier.Reorg do
  @moduledoc """
  TODO(wilmer): need to know how the client will use this first.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.ChainNotifier.ConfEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :event, 0

  field :conf, 1, type: Lightnex.RPC.ChainNotifier.ConfDetails, oneof: 0
  field :reorg, 2, type: Lightnex.RPC.ChainNotifier.Reorg, oneof: 0
end

defmodule Lightnex.RPC.ChainNotifier.Outpoint do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :hash, 1, type: :bytes
  field :index, 2, type: :uint32
end

defmodule Lightnex.RPC.ChainNotifier.SpendRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :outpoint, 1, type: Lightnex.RPC.ChainNotifier.Outpoint
  field :script, 2, type: :bytes
  field :height_hint, 3, type: :uint32, json_name: "heightHint"
end

defmodule Lightnex.RPC.ChainNotifier.SpendDetails do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :spending_outpoint, 1,
    type: Lightnex.RPC.ChainNotifier.Outpoint,
    json_name: "spendingOutpoint"

  field :raw_spending_tx, 2, type: :bytes, json_name: "rawSpendingTx"
  field :spending_tx_hash, 3, type: :bytes, json_name: "spendingTxHash"
  field :spending_input_index, 4, type: :uint32, json_name: "spendingInputIndex"
  field :spending_height, 5, type: :uint32, json_name: "spendingHeight"
end

defmodule Lightnex.RPC.ChainNotifier.SpendEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :event, 0

  field :spend, 1, type: Lightnex.RPC.ChainNotifier.SpendDetails, oneof: 0
  field :reorg, 2, type: Lightnex.RPC.ChainNotifier.Reorg, oneof: 0
end

defmodule Lightnex.RPC.ChainNotifier.BlockEpoch do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :hash, 1, type: :bytes
  field :height, 2, type: :uint32
end

defmodule Lightnex.RPC.ChainNotifier.Service do
  @moduledoc """
  ChainNotifier is a service that can be used to get information about the
  chain backend by registering notifiers for chain events.
  """

  use GRPC.Service, name: "chainrpc.ChainNotifier", protoc_gen_elixir_version: "0.15.0"

  rpc :RegisterConfirmationsNtfn,
      Lightnex.RPC.ChainNotifier.ConfRequest,
      stream(Lightnex.RPC.ChainNotifier.ConfEvent)

  rpc :RegisterSpendNtfn,
      Lightnex.RPC.ChainNotifier.SpendRequest,
      stream(Lightnex.RPC.ChainNotifier.SpendEvent)

  rpc :RegisterBlockEpochNtfn,
      Lightnex.RPC.ChainNotifier.BlockEpoch,
      stream(Lightnex.RPC.ChainNotifier.BlockEpoch)
end

defmodule Lightnex.RPC.ChainNotifier.Stub do
  use GRPC.Stub, service: Lightnex.RPC.ChainNotifier.Service
end
