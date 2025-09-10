defmodule Lightnex.RPC.Peers.UpdateAction do
  @moduledoc """
  UpdateAction is used to determine the kind of action we are referring to.
  """

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :ADD, 0
  field :REMOVE, 1
end

defmodule Lightnex.RPC.Peers.FeatureSet do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :SET_INIT, 0
  field :SET_LEGACY_GLOBAL, 1
  field :SET_NODE_ANN, 2
  field :SET_INVOICE, 3
  field :SET_INVOICE_AMP, 4
end

defmodule Lightnex.RPC.Peers.UpdateAddressAction do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :action, 1, type: Lightnex.RPC.Peers.UpdateAction, enum: true
  field :address, 2, type: :string
end

defmodule Lightnex.RPC.Peers.UpdateFeatureAction do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :action, 1, type: Lightnex.RPC.Peers.UpdateAction, enum: true

  field :feature_bit, 2,
    type: Lightnex.RPC.Lightning.FeatureBit,
    json_name: "featureBit",
    enum: true
end

defmodule Lightnex.RPC.Peers.NodeAnnouncementUpdateRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :feature_updates, 1,
    repeated: true,
    type: Lightnex.RPC.Peers.UpdateFeatureAction,
    json_name: "featureUpdates"

  field :color, 2, type: :string
  field :alias, 3, type: :string

  field :address_updates, 4,
    repeated: true,
    type: Lightnex.RPC.Peers.UpdateAddressAction,
    json_name: "addressUpdates"
end

defmodule Lightnex.RPC.Peers.NodeAnnouncementUpdateResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :ops, 1, repeated: true, type: Lightnex.RPC.Lightning.Op
end

defmodule Lightnex.RPC.Peers.Service do
  @moduledoc """
  Peers is a service that can be used to get information and interact
  with the other nodes of the network.
  """

  use GRPC.Service, name: "peersrpc.Peers", protoc_gen_elixir_version: "0.15.0"

  rpc :UpdateNodeAnnouncement,
      Lightnex.RPC.Peers.NodeAnnouncementUpdateRequest,
      Lightnex.RPC.Peers.NodeAnnouncementUpdateResponse
end

defmodule Lightnex.RPC.Peers.Stub do
  use GRPC.Stub, service: Lightnex.RPC.Peers.Service
end
