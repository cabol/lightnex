defmodule Lightnex.LNRPC.ChainNotifier.ConfRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid, 1, type: :bytes
  field :script, 2, type: :bytes
  field :num_confs, 3, type: :uint32, json_name: "numConfs"
  field :height_hint, 4, type: :uint32, json_name: "heightHint"
  field :include_block, 5, type: :bool, json_name: "includeBlock"
end

defmodule Lightnex.LNRPC.ChainNotifier.ConfDetails do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_tx, 1, type: :bytes, json_name: "rawTx"
  field :block_hash, 2, type: :bytes, json_name: "blockHash"
  field :block_height, 3, type: :uint32, json_name: "blockHeight"
  field :tx_index, 4, type: :uint32, json_name: "txIndex"
  field :raw_block, 5, type: :bytes, json_name: "rawBlock"
end

defmodule Lightnex.LNRPC.ChainNotifier.Reorg do
  @moduledoc """
  TODO(wilmer): need to know how the client will use this first.
  """

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.ChainNotifier.ConfEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :event, 0

  field :conf, 1, type: Lightnex.LNRPC.ChainNotifier.ConfDetails, oneof: 0
  field :reorg, 2, type: Lightnex.LNRPC.ChainNotifier.Reorg, oneof: 0
end

defmodule Lightnex.LNRPC.ChainNotifier.Outpoint do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :hash, 1, type: :bytes
  field :index, 2, type: :uint32
end

defmodule Lightnex.LNRPC.ChainNotifier.SpendRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :outpoint, 1, type: Lightnex.LNRPC.ChainNotifier.Outpoint
  field :script, 2, type: :bytes
  field :height_hint, 3, type: :uint32, json_name: "heightHint"
end

defmodule Lightnex.LNRPC.ChainNotifier.SpendDetails do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :spending_outpoint, 1,
    type: Lightnex.LNRPC.ChainNotifier.Outpoint,
    json_name: "spendingOutpoint"

  field :raw_spending_tx, 2, type: :bytes, json_name: "rawSpendingTx"
  field :spending_tx_hash, 3, type: :bytes, json_name: "spendingTxHash"
  field :spending_input_index, 4, type: :uint32, json_name: "spendingInputIndex"
  field :spending_height, 5, type: :uint32, json_name: "spendingHeight"
end

defmodule Lightnex.LNRPC.ChainNotifier.SpendEvent do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :event, 0

  field :spend, 1, type: Lightnex.LNRPC.ChainNotifier.SpendDetails, oneof: 0
  field :reorg, 2, type: Lightnex.LNRPC.ChainNotifier.Reorg, oneof: 0
end

defmodule Lightnex.LNRPC.ChainNotifier.BlockEpoch do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :hash, 1, type: :bytes
  field :height, 2, type: :uint32
end

defmodule Lightnex.LNRPC.ChainNotifier.Service do
  @moduledoc """
  ChainNotifier is a service that can be used to get information about the
  chain backend by registering notifiers for chain events.
  """

  use GRPC.Service, name: "chainrpc.ChainNotifier", protoc_gen_elixir_version: "0.15.0"

  rpc :RegisterConfirmationsNtfn,
      Lightnex.LNRPC.ChainNotifier.ConfRequest,
      stream(Lightnex.LNRPC.ChainNotifier.ConfEvent)

  rpc :RegisterSpendNtfn,
      Lightnex.LNRPC.ChainNotifier.SpendRequest,
      stream(Lightnex.LNRPC.ChainNotifier.SpendEvent)

  rpc :RegisterBlockEpochNtfn,
      Lightnex.LNRPC.ChainNotifier.BlockEpoch,
      stream(Lightnex.LNRPC.ChainNotifier.BlockEpoch)
end

defmodule Lightnex.LNRPC.ChainNotifier.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.ChainNotifier.Service
end
