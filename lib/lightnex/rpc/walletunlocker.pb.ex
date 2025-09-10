defmodule Lightnex.RPC.WalletUnlocker.GenSeedRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :aezeed_passphrase, 1, type: :bytes, json_name: "aezeedPassphrase"
  field :seed_entropy, 2, type: :bytes, json_name: "seedEntropy"
end

defmodule Lightnex.RPC.WalletUnlocker.GenSeedResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :cipher_seed_mnemonic, 1, repeated: true, type: :string, json_name: "cipherSeedMnemonic"
  field :enciphered_seed, 2, type: :bytes, json_name: "encipheredSeed"
end

defmodule Lightnex.RPC.WalletUnlocker.InitWalletRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :wallet_password, 1, type: :bytes, json_name: "walletPassword"
  field :cipher_seed_mnemonic, 2, repeated: true, type: :string, json_name: "cipherSeedMnemonic"
  field :aezeed_passphrase, 3, type: :bytes, json_name: "aezeedPassphrase"
  field :recovery_window, 4, type: :int32, json_name: "recoveryWindow"

  field :channel_backups, 5,
    type: Lightnex.RPC.Lightning.ChanBackupSnapshot,
    json_name: "channelBackups"

  field :stateless_init, 6, type: :bool, json_name: "statelessInit"
  field :extended_master_key, 7, type: :string, json_name: "extendedMasterKey"

  field :extended_master_key_birthday_timestamp, 8,
    type: :uint64,
    json_name: "extendedMasterKeyBirthdayTimestamp"

  field :watch_only, 9, type: Lightnex.RPC.WalletUnlocker.WatchOnly, json_name: "watchOnly"
  field :macaroon_root_key, 10, type: :bytes, json_name: "macaroonRootKey"
end

defmodule Lightnex.RPC.WalletUnlocker.InitWalletResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :admin_macaroon, 1, type: :bytes, json_name: "adminMacaroon"
end

defmodule Lightnex.RPC.WalletUnlocker.WatchOnly do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :master_key_birthday_timestamp, 1, type: :uint64, json_name: "masterKeyBirthdayTimestamp"
  field :master_key_fingerprint, 2, type: :bytes, json_name: "masterKeyFingerprint"
  field :accounts, 3, repeated: true, type: Lightnex.RPC.WalletUnlocker.WatchOnlyAccount
end

defmodule Lightnex.RPC.WalletUnlocker.WatchOnlyAccount do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :purpose, 1, type: :uint32
  field :coin_type, 2, type: :uint32, json_name: "coinType"
  field :account, 3, type: :uint32
  field :xpub, 4, type: :string
end

defmodule Lightnex.RPC.WalletUnlocker.UnlockWalletRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :wallet_password, 1, type: :bytes, json_name: "walletPassword"
  field :recovery_window, 2, type: :int32, json_name: "recoveryWindow"

  field :channel_backups, 3,
    type: Lightnex.RPC.Lightning.ChanBackupSnapshot,
    json_name: "channelBackups"

  field :stateless_init, 4, type: :bool, json_name: "statelessInit"
end

defmodule Lightnex.RPC.WalletUnlocker.UnlockWalletResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.RPC.WalletUnlocker.ChangePasswordRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :current_password, 1, type: :bytes, json_name: "currentPassword"
  field :new_password, 2, type: :bytes, json_name: "newPassword"
  field :stateless_init, 3, type: :bool, json_name: "statelessInit"
  field :new_macaroon_root_key, 4, type: :bool, json_name: "newMacaroonRootKey"
end

defmodule Lightnex.RPC.WalletUnlocker.ChangePasswordResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :admin_macaroon, 1, type: :bytes, json_name: "adminMacaroon"
end

defmodule Lightnex.RPC.WalletUnlocker.Service do
  @moduledoc """
  WalletUnlocker is a service that is used to set up a wallet password for
  lnd at first startup, and unlock a previously set up wallet.
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

  use GRPC.Service, name: "lnrpc.WalletUnlocker", protoc_gen_elixir_version: "0.15.0"

  rpc :GenSeed,
      Lightnex.RPC.WalletUnlocker.GenSeedRequest,
      Lightnex.RPC.WalletUnlocker.GenSeedResponse

  rpc :InitWallet,
      Lightnex.RPC.WalletUnlocker.InitWalletRequest,
      Lightnex.RPC.WalletUnlocker.InitWalletResponse

  rpc :UnlockWallet,
      Lightnex.RPC.WalletUnlocker.UnlockWalletRequest,
      Lightnex.RPC.WalletUnlocker.UnlockWalletResponse

  rpc :ChangePassword,
      Lightnex.RPC.WalletUnlocker.ChangePasswordRequest,
      Lightnex.RPC.WalletUnlocker.ChangePasswordResponse
end

defmodule Lightnex.RPC.WalletUnlocker.Stub do
  use GRPC.Stub, service: Lightnex.RPC.WalletUnlocker.Service
end
