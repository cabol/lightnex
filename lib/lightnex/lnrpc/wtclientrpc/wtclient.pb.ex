defmodule Lightnex.LNRPC.WatchtowerClient.PolicyType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :LEGACY, 0
  field :ANCHOR, 1
  field :TAPROOT, 2
end

defmodule Lightnex.LNRPC.WatchtowerClient.AddTowerRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pubkey, 1, type: :bytes
  field :address, 2, type: :string
end

defmodule Lightnex.LNRPC.WatchtowerClient.AddTowerResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.WatchtowerClient.RemoveTowerRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pubkey, 1, type: :bytes
  field :address, 2, type: :string
end

defmodule Lightnex.LNRPC.WatchtowerClient.RemoveTowerResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.WatchtowerClient.DeactivateTowerRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pubkey, 1, type: :bytes
end

defmodule Lightnex.LNRPC.WatchtowerClient.DeactivateTowerResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WatchtowerClient.TerminateSessionRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :session_id, 1, type: :bytes, json_name: "sessionId"
end

defmodule Lightnex.LNRPC.WatchtowerClient.TerminateSessionResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WatchtowerClient.GetTowerInfoRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pubkey, 1, type: :bytes
  field :include_sessions, 2, type: :bool, json_name: "includeSessions"
  field :exclude_exhausted_sessions, 3, type: :bool, json_name: "excludeExhaustedSessions"
end

defmodule Lightnex.LNRPC.WatchtowerClient.TowerSession do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :num_backups, 1, type: :uint32, json_name: "numBackups"
  field :num_pending_backups, 2, type: :uint32, json_name: "numPendingBackups"
  field :max_backups, 3, type: :uint32, json_name: "maxBackups"
  field :sweep_sat_per_byte, 4, type: :uint32, json_name: "sweepSatPerByte", deprecated: true
  field :sweep_sat_per_vbyte, 5, type: :uint32, json_name: "sweepSatPerVbyte"
  field :id, 6, type: :bytes
end

defmodule Lightnex.LNRPC.WatchtowerClient.Tower do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pubkey, 1, type: :bytes
  field :addresses, 2, repeated: true, type: :string

  field :active_session_candidate, 3,
    type: :bool,
    json_name: "activeSessionCandidate",
    deprecated: true

  field :num_sessions, 4, type: :uint32, json_name: "numSessions", deprecated: true

  field :sessions, 5,
    repeated: true,
    type: Lightnex.LNRPC.WatchtowerClient.TowerSession,
    deprecated: true

  field :session_info, 6,
    repeated: true,
    type: Lightnex.LNRPC.WatchtowerClient.TowerSessionInfo,
    json_name: "sessionInfo"
end

defmodule Lightnex.LNRPC.WatchtowerClient.TowerSessionInfo do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :active_session_candidate, 1, type: :bool, json_name: "activeSessionCandidate"
  field :num_sessions, 2, type: :uint32, json_name: "numSessions"
  field :sessions, 3, repeated: true, type: Lightnex.LNRPC.WatchtowerClient.TowerSession

  field :policy_type, 4,
    type: Lightnex.LNRPC.WatchtowerClient.PolicyType,
    json_name: "policyType",
    enum: true
end

defmodule Lightnex.LNRPC.WatchtowerClient.ListTowersRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :include_sessions, 1, type: :bool, json_name: "includeSessions"
  field :exclude_exhausted_sessions, 2, type: :bool, json_name: "excludeExhaustedSessions"
end

defmodule Lightnex.LNRPC.WatchtowerClient.ListTowersResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :towers, 1, repeated: true, type: Lightnex.LNRPC.WatchtowerClient.Tower
end

defmodule Lightnex.LNRPC.WatchtowerClient.StatsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.WatchtowerClient.StatsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :num_backups, 1, type: :uint32, json_name: "numBackups"
  field :num_pending_backups, 2, type: :uint32, json_name: "numPendingBackups"
  field :num_failed_backups, 3, type: :uint32, json_name: "numFailedBackups"
  field :num_sessions_acquired, 4, type: :uint32, json_name: "numSessionsAcquired"
  field :num_sessions_exhausted, 5, type: :uint32, json_name: "numSessionsExhausted"
end

defmodule Lightnex.LNRPC.WatchtowerClient.PolicyRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :policy_type, 1,
    type: Lightnex.LNRPC.WatchtowerClient.PolicyType,
    json_name: "policyType",
    enum: true
end

defmodule Lightnex.LNRPC.WatchtowerClient.PolicyResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :max_updates, 1, type: :uint32, json_name: "maxUpdates"
  field :sweep_sat_per_byte, 2, type: :uint32, json_name: "sweepSatPerByte", deprecated: true
  field :sweep_sat_per_vbyte, 3, type: :uint32, json_name: "sweepSatPerVbyte"
end

defmodule Lightnex.LNRPC.WatchtowerClient.Service do
  @moduledoc """
  WatchtowerClient is a service that grants access to the watchtower client
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

  use GRPC.Service, name: "wtclientrpc.WatchtowerClient", protoc_gen_elixir_version: "0.15.0"

  rpc :AddTower,
      Lightnex.LNRPC.WatchtowerClient.AddTowerRequest,
      Lightnex.LNRPC.WatchtowerClient.AddTowerResponse

  rpc :RemoveTower,
      Lightnex.LNRPC.WatchtowerClient.RemoveTowerRequest,
      Lightnex.LNRPC.WatchtowerClient.RemoveTowerResponse

  rpc :DeactivateTower,
      Lightnex.LNRPC.WatchtowerClient.DeactivateTowerRequest,
      Lightnex.LNRPC.WatchtowerClient.DeactivateTowerResponse

  rpc :TerminateSession,
      Lightnex.LNRPC.WatchtowerClient.TerminateSessionRequest,
      Lightnex.LNRPC.WatchtowerClient.TerminateSessionResponse

  rpc :ListTowers,
      Lightnex.LNRPC.WatchtowerClient.ListTowersRequest,
      Lightnex.LNRPC.WatchtowerClient.ListTowersResponse

  rpc :GetTowerInfo,
      Lightnex.LNRPC.WatchtowerClient.GetTowerInfoRequest,
      Lightnex.LNRPC.WatchtowerClient.Tower

  rpc :Stats,
      Lightnex.LNRPC.WatchtowerClient.StatsRequest,
      Lightnex.LNRPC.WatchtowerClient.StatsResponse

  rpc :Policy,
      Lightnex.LNRPC.WatchtowerClient.PolicyRequest,
      Lightnex.LNRPC.WatchtowerClient.PolicyResponse
end

defmodule Lightnex.LNRPC.WatchtowerClient.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.WatchtowerClient.Service
end
