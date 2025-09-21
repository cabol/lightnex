defmodule Lightnex.LNRPC.WalletKit.AddressType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN, 0
  field :WITNESS_PUBKEY_HASH, 1
  field :NESTED_WITNESS_PUBKEY_HASH, 2
  field :HYBRID_NESTED_WITNESS_PUBKEY_HASH, 3
  field :TAPROOT_PUBKEY, 4
end

defmodule Lightnex.LNRPC.WalletKit.WitnessType do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :UNKNOWN_WITNESS, 0
  field :COMMITMENT_TIME_LOCK, 1
  field :COMMITMENT_NO_DELAY, 2
  field :COMMITMENT_REVOKE, 3
  field :HTLC_OFFERED_REVOKE, 4
  field :HTLC_ACCEPTED_REVOKE, 5
  field :HTLC_OFFERED_TIMEOUT_SECOND_LEVEL, 6
  field :HTLC_ACCEPTED_SUCCESS_SECOND_LEVEL, 7
  field :HTLC_OFFERED_REMOTE_TIMEOUT, 8
  field :HTLC_ACCEPTED_REMOTE_SUCCESS, 9
  field :HTLC_SECOND_LEVEL_REVOKE, 10
  field :WITNESS_KEY_HASH, 11
  field :NESTED_WITNESS_KEY_HASH, 12
  field :COMMITMENT_ANCHOR, 13
  field :COMMITMENT_NO_DELAY_TWEAKLESS, 14
  field :COMMITMENT_TO_REMOTE_CONFIRMED, 15
  field :HTLC_OFFERED_TIMEOUT_SECOND_LEVEL_INPUT_CONFIRMED, 16
  field :HTLC_ACCEPTED_SUCCESS_SECOND_LEVEL_INPUT_CONFIRMED, 17
  field :LEASE_COMMITMENT_TIME_LOCK, 18
  field :LEASE_COMMITMENT_TO_REMOTE_CONFIRMED, 19
  field :LEASE_HTLC_OFFERED_TIMEOUT_SECOND_LEVEL, 20
  field :LEASE_HTLC_ACCEPTED_SUCCESS_SECOND_LEVEL, 21
  field :TAPROOT_PUB_KEY_SPEND, 22
  field :TAPROOT_LOCAL_COMMIT_SPEND, 23
  field :TAPROOT_REMOTE_COMMIT_SPEND, 24
  field :TAPROOT_ANCHOR_SWEEP_SPEND, 25
  field :TAPROOT_HTLC_OFFERED_TIMEOUT_SECOND_LEVEL, 26
  field :TAPROOT_HTLC_ACCEPTED_SUCCESS_SECOND_LEVEL, 27
  field :TAPROOT_HTLC_SECOND_LEVEL_REVOKE, 28
  field :TAPROOT_HTLC_ACCEPTED_REVOKE, 29
  field :TAPROOT_HTLC_OFFERED_REVOKE, 30
  field :TAPROOT_HTLC_OFFERED_REMOTE_TIMEOUT, 31
  field :TAPROOT_HTLC_LOCAL_OFFERED_TIMEOUT, 32
  field :TAPROOT_HTLC_ACCEPTED_REMOTE_SUCCESS, 33
  field :TAPROOT_HTLC_ACCEPTED_LOCAL_SUCCESS, 34
  field :TAPROOT_COMMITMENT_REVOKE, 35
end

defmodule Lightnex.LNRPC.WalletKit.ChangeAddressType do
  @moduledoc """
  The possible change address types for default accounts and single imported
  public keys. By default, P2WPKH will be used. We don't provide the
  possibility to choose P2PKH as it is a legacy key scope, nor NP2WPKH as
  no key scope permits to do so. For custom accounts, no change type should
  be provided as the coin selection key scope will always be used to generate
  the change address.
  """

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :CHANGE_ADDRESS_TYPE_UNSPECIFIED, 0
  field :CHANGE_ADDRESS_TYPE_P2TR, 1
end

defmodule Lightnex.LNRPC.WalletKit.ListUnspentRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :min_confs, 1, type: :int32, json_name: "minConfs"
  field :max_confs, 2, type: :int32, json_name: "maxConfs"
  field :account, 3, type: :string
  field :unconfirmed_only, 4, type: :bool, json_name: "unconfirmedOnly"
end

defmodule Lightnex.LNRPC.WalletKit.ListUnspentResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :utxos, 1, repeated: true, type: Lightnex.LNRPC.Lightning.Utxo
end

defmodule Lightnex.LNRPC.WalletKit.LeaseOutputRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :bytes
  field :outpoint, 2, type: Lightnex.LNRPC.Lightning.OutPoint
  field :expiration_seconds, 3, type: :uint64, json_name: "expirationSeconds"
end

defmodule Lightnex.LNRPC.WalletKit.LeaseOutputResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :expiration, 1, type: :uint64
end

defmodule Lightnex.LNRPC.WalletKit.ReleaseOutputRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :bytes
  field :outpoint, 2, type: Lightnex.LNRPC.Lightning.OutPoint
end

defmodule Lightnex.LNRPC.WalletKit.ReleaseOutputResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.KeyReq do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key_finger_print, 1, type: :int32, json_name: "keyFingerPrint"
  field :key_family, 2, type: :int32, json_name: "keyFamily"
end

defmodule Lightnex.LNRPC.WalletKit.AddrRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :account, 1, type: :string
  field :type, 2, type: Lightnex.LNRPC.WalletKit.AddressType, enum: true
  field :change, 3, type: :bool
end

defmodule Lightnex.LNRPC.WalletKit.AddrResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :addr, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.Account do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :name, 1, type: :string

  field :address_type, 2,
    type: Lightnex.LNRPC.WalletKit.AddressType,
    json_name: "addressType",
    enum: true

  field :extended_public_key, 3, type: :string, json_name: "extendedPublicKey"
  field :master_key_fingerprint, 4, type: :bytes, json_name: "masterKeyFingerprint"
  field :derivation_path, 5, type: :string, json_name: "derivationPath"
  field :external_key_count, 6, type: :uint32, json_name: "externalKeyCount"
  field :internal_key_count, 7, type: :uint32, json_name: "internalKeyCount"
  field :watch_only, 8, type: :bool, json_name: "watchOnly"
end

defmodule Lightnex.LNRPC.WalletKit.AddressProperty do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :address, 1, type: :string
  field :is_internal, 2, type: :bool, json_name: "isInternal"
  field :balance, 3, type: :int64
  field :derivation_path, 4, type: :string, json_name: "derivationPath"
  field :public_key, 5, type: :bytes, json_name: "publicKey"
end

defmodule Lightnex.LNRPC.WalletKit.AccountWithAddresses do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :name, 1, type: :string

  field :address_type, 2,
    type: Lightnex.LNRPC.WalletKit.AddressType,
    json_name: "addressType",
    enum: true

  field :derivation_path, 3, type: :string, json_name: "derivationPath"
  field :addresses, 4, repeated: true, type: Lightnex.LNRPC.WalletKit.AddressProperty
end

defmodule Lightnex.LNRPC.WalletKit.ListAccountsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :name, 1, type: :string

  field :address_type, 2,
    type: Lightnex.LNRPC.WalletKit.AddressType,
    json_name: "addressType",
    enum: true
end

defmodule Lightnex.LNRPC.WalletKit.ListAccountsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :accounts, 1, repeated: true, type: Lightnex.LNRPC.WalletKit.Account
end

defmodule Lightnex.LNRPC.WalletKit.RequiredReserveRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :additional_public_channels, 1, type: :uint32, json_name: "additionalPublicChannels"
end

defmodule Lightnex.LNRPC.WalletKit.RequiredReserveResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :required_reserve, 1, type: :int64, json_name: "requiredReserve"
end

defmodule Lightnex.LNRPC.WalletKit.ListAddressesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :account_name, 1, type: :string, json_name: "accountName"
  field :show_custom_accounts, 2, type: :bool, json_name: "showCustomAccounts"
end

defmodule Lightnex.LNRPC.WalletKit.ListAddressesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :account_with_addresses, 1,
    repeated: true,
    type: Lightnex.LNRPC.WalletKit.AccountWithAddresses,
    json_name: "accountWithAddresses"
end

defmodule Lightnex.LNRPC.WalletKit.GetTransactionRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.SignMessageWithAddrRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :msg, 1, type: :bytes
  field :addr, 2, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.SignMessageWithAddrResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :signature, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.VerifyMessageWithAddrRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :msg, 1, type: :bytes
  field :signature, 2, type: :string
  field :addr, 3, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.VerifyMessageWithAddrResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :valid, 1, type: :bool
  field :pubkey, 2, type: :bytes
end

defmodule Lightnex.LNRPC.WalletKit.ImportAccountRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :name, 1, type: :string
  field :extended_public_key, 2, type: :string, json_name: "extendedPublicKey"
  field :master_key_fingerprint, 3, type: :bytes, json_name: "masterKeyFingerprint"

  field :address_type, 4,
    type: Lightnex.LNRPC.WalletKit.AddressType,
    json_name: "addressType",
    enum: true

  field :dry_run, 5, type: :bool, json_name: "dryRun"
end

defmodule Lightnex.LNRPC.WalletKit.ImportAccountResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :account, 1, type: Lightnex.LNRPC.WalletKit.Account

  field :dry_run_external_addrs, 2,
    repeated: true,
    type: :string,
    json_name: "dryRunExternalAddrs"

  field :dry_run_internal_addrs, 3,
    repeated: true,
    type: :string,
    json_name: "dryRunInternalAddrs"
end

defmodule Lightnex.LNRPC.WalletKit.ImportPublicKeyRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :public_key, 1, type: :bytes, json_name: "publicKey"

  field :address_type, 2,
    type: Lightnex.LNRPC.WalletKit.AddressType,
    json_name: "addressType",
    enum: true
end

defmodule Lightnex.LNRPC.WalletKit.ImportPublicKeyResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.ImportTapscriptRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :script, 0

  field :internal_public_key, 1, type: :bytes, json_name: "internalPublicKey"

  field :full_tree, 2,
    type: Lightnex.LNRPC.WalletKit.TapscriptFullTree,
    json_name: "fullTree",
    oneof: 0

  field :partial_reveal, 3,
    type: Lightnex.LNRPC.WalletKit.TapscriptPartialReveal,
    json_name: "partialReveal",
    oneof: 0

  field :root_hash_only, 4, type: :bytes, json_name: "rootHashOnly", oneof: 0
  field :full_key_only, 5, type: :bool, json_name: "fullKeyOnly", oneof: 0
end

defmodule Lightnex.LNRPC.WalletKit.TapscriptFullTree do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :all_leaves, 1,
    repeated: true,
    type: Lightnex.LNRPC.WalletKit.TapLeaf,
    json_name: "allLeaves"
end

defmodule Lightnex.LNRPC.WalletKit.TapLeaf do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :leaf_version, 1, type: :uint32, json_name: "leafVersion"
  field :script, 2, type: :bytes
end

defmodule Lightnex.LNRPC.WalletKit.TapscriptPartialReveal do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :revealed_leaf, 1, type: Lightnex.LNRPC.WalletKit.TapLeaf, json_name: "revealedLeaf"
  field :full_inclusion_proof, 2, type: :bytes, json_name: "fullInclusionProof"
end

defmodule Lightnex.LNRPC.WalletKit.ImportTapscriptResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :p2tr_address, 1, type: :string, json_name: "p2trAddress"
end

defmodule Lightnex.LNRPC.WalletKit.Transaction do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :tx_hex, 1, type: :bytes, json_name: "txHex"
  field :label, 2, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.PublishResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :publish_error, 1, type: :string, json_name: "publishError"
end

defmodule Lightnex.LNRPC.WalletKit.RemoveTransactionResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.SendOutputsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :sat_per_kw, 1, type: :int64, json_name: "satPerKw"
  field :outputs, 2, repeated: true, type: Lightnex.LNRPC.Signer.TxOut
  field :label, 3, type: :string
  field :min_confs, 4, type: :int32, json_name: "minConfs"
  field :spend_unconfirmed, 5, type: :bool, json_name: "spendUnconfirmed"

  field :coin_selection_strategy, 6,
    type: Lightnex.LNRPC.Lightning.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true
end

defmodule Lightnex.LNRPC.WalletKit.SendOutputsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_tx, 1, type: :bytes, json_name: "rawTx"
end

defmodule Lightnex.LNRPC.WalletKit.EstimateFeeRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :conf_target, 1, type: :int32, json_name: "confTarget"
end

defmodule Lightnex.LNRPC.WalletKit.EstimateFeeResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :sat_per_kw, 1, type: :int64, json_name: "satPerKw"
  field :min_relay_fee_sat_per_kw, 2, type: :int64, json_name: "minRelayFeeSatPerKw"
end

defmodule Lightnex.LNRPC.WalletKit.PendingSweep do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :outpoint, 1, type: Lightnex.LNRPC.Lightning.OutPoint

  field :witness_type, 2,
    type: Lightnex.LNRPC.WalletKit.WitnessType,
    json_name: "witnessType",
    enum: true

  field :amount_sat, 3, type: :uint32, json_name: "amountSat"
  field :sat_per_byte, 4, type: :uint32, json_name: "satPerByte", deprecated: true
  field :broadcast_attempts, 5, type: :uint32, json_name: "broadcastAttempts"

  field :next_broadcast_height, 6,
    type: :uint32,
    json_name: "nextBroadcastHeight",
    deprecated: true

  field :force, 7, type: :bool, deprecated: true

  field :requested_conf_target, 8,
    type: :uint32,
    json_name: "requestedConfTarget",
    deprecated: true

  field :requested_sat_per_byte, 9,
    type: :uint32,
    json_name: "requestedSatPerByte",
    deprecated: true

  field :sat_per_vbyte, 10, type: :uint64, json_name: "satPerVbyte"
  field :requested_sat_per_vbyte, 11, type: :uint64, json_name: "requestedSatPerVbyte"
  field :immediate, 12, type: :bool
  field :budget, 13, type: :uint64
  field :deadline_height, 14, type: :uint32, json_name: "deadlineHeight"
  field :maturity_height, 15, type: :uint32, json_name: "maturityHeight"
end

defmodule Lightnex.LNRPC.WalletKit.PendingSweepsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.WalletKit.PendingSweepsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :pending_sweeps, 1,
    repeated: true,
    type: Lightnex.LNRPC.WalletKit.PendingSweep,
    json_name: "pendingSweeps"
end

defmodule Lightnex.LNRPC.WalletKit.BumpFeeRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :outpoint, 1, type: Lightnex.LNRPC.Lightning.OutPoint
  field :target_conf, 2, type: :uint32, json_name: "targetConf"
  field :sat_per_byte, 3, type: :uint32, json_name: "satPerByte", deprecated: true
  field :force, 4, type: :bool, deprecated: true
  field :sat_per_vbyte, 5, type: :uint64, json_name: "satPerVbyte"
  field :immediate, 6, type: :bool
  field :budget, 7, type: :uint64
  field :deadline_delta, 8, type: :uint32, json_name: "deadlineDelta"
end

defmodule Lightnex.LNRPC.WalletKit.BumpFeeResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.BumpForceCloseFeeRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :chan_point, 1, type: Lightnex.LNRPC.Lightning.ChannelPoint, json_name: "chanPoint"
  field :deadline_delta, 2, type: :uint32, json_name: "deadlineDelta"
  field :starting_feerate, 3, type: :uint64, json_name: "startingFeerate"
  field :immediate, 4, type: :bool
  field :budget, 5, type: :uint64
  field :target_conf, 6, type: :uint32, json_name: "targetConf"
end

defmodule Lightnex.LNRPC.WalletKit.BumpForceCloseFeeResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.ListSweepsRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :verbose, 1, type: :bool
  field :start_height, 2, type: :int32, json_name: "startHeight"
end

defmodule Lightnex.LNRPC.WalletKit.ListSweepsResponse.TransactionIDs do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :transaction_ids, 1, repeated: true, type: :string, json_name: "transactionIds"
end

defmodule Lightnex.LNRPC.WalletKit.ListSweepsResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :sweeps, 0

  field :transaction_details, 1,
    type: Lightnex.LNRPC.Lightning.TransactionDetails,
    json_name: "transactionDetails",
    oneof: 0

  field :transaction_ids, 2,
    type: Lightnex.LNRPC.WalletKit.ListSweepsResponse.TransactionIDs,
    json_name: "transactionIds",
    oneof: 0
end

defmodule Lightnex.LNRPC.WalletKit.LabelTransactionRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :txid, 1, type: :bytes
  field :label, 2, type: :string
  field :overwrite, 3, type: :bool
end

defmodule Lightnex.LNRPC.WalletKit.LabelTransactionResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :status, 1, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.FundPsbtRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :template, 0

  oneof :fees, 1

  field :psbt, 1, type: :bytes, oneof: 0
  field :raw, 2, type: Lightnex.LNRPC.WalletKit.TxTemplate, oneof: 0

  field :coin_select, 9,
    type: Lightnex.LNRPC.WalletKit.PsbtCoinSelect,
    json_name: "coinSelect",
    oneof: 0

  field :target_conf, 3, type: :uint32, json_name: "targetConf", oneof: 1
  field :sat_per_vbyte, 4, type: :uint64, json_name: "satPerVbyte", oneof: 1
  field :sat_per_kw, 11, type: :uint64, json_name: "satPerKw", oneof: 1
  field :account, 5, type: :string
  field :min_confs, 6, type: :int32, json_name: "minConfs"
  field :spend_unconfirmed, 7, type: :bool, json_name: "spendUnconfirmed"

  field :change_type, 8,
    type: Lightnex.LNRPC.WalletKit.ChangeAddressType,
    json_name: "changeType",
    enum: true

  field :coin_selection_strategy, 10,
    type: Lightnex.LNRPC.Lightning.CoinSelectionStrategy,
    json_name: "coinSelectionStrategy",
    enum: true

  field :max_fee_ratio, 12, type: :double, json_name: "maxFeeRatio"
  field :custom_lock_id, 13, type: :bytes, json_name: "customLockId"
  field :lock_expiration_seconds, 14, type: :uint64, json_name: "lockExpirationSeconds"
end

defmodule Lightnex.LNRPC.WalletKit.FundPsbtResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :funded_psbt, 1, type: :bytes, json_name: "fundedPsbt"
  field :change_output_index, 2, type: :int32, json_name: "changeOutputIndex"

  field :locked_utxos, 3,
    repeated: true,
    type: Lightnex.LNRPC.WalletKit.UtxoLease,
    json_name: "lockedUtxos"
end

defmodule Lightnex.LNRPC.WalletKit.TxTemplate.OutputsEntry do
  use Protobuf, map: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :uint64
end

defmodule Lightnex.LNRPC.WalletKit.TxTemplate do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :inputs, 1, repeated: true, type: Lightnex.LNRPC.Lightning.OutPoint

  field :outputs, 2,
    repeated: true,
    type: Lightnex.LNRPC.WalletKit.TxTemplate.OutputsEntry,
    map: true
end

defmodule Lightnex.LNRPC.WalletKit.PsbtCoinSelect do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  oneof :change_output, 0

  field :psbt, 1, type: :bytes
  field :existing_output_index, 2, type: :int32, json_name: "existingOutputIndex", oneof: 0
  field :add, 3, type: :bool, oneof: 0
end

defmodule Lightnex.LNRPC.WalletKit.UtxoLease do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :bytes
  field :outpoint, 2, type: Lightnex.LNRPC.Lightning.OutPoint
  field :expiration, 3, type: :uint64
  field :pk_script, 4, type: :bytes, json_name: "pkScript"
  field :value, 5, type: :uint64
end

defmodule Lightnex.LNRPC.WalletKit.SignPsbtRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :funded_psbt, 1, type: :bytes, json_name: "fundedPsbt"
end

defmodule Lightnex.LNRPC.WalletKit.SignPsbtResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :signed_psbt, 1, type: :bytes, json_name: "signedPsbt"
  field :signed_inputs, 2, repeated: true, type: :uint32, json_name: "signedInputs"
end

defmodule Lightnex.LNRPC.WalletKit.FinalizePsbtRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :funded_psbt, 1, type: :bytes, json_name: "fundedPsbt"
  field :account, 5, type: :string
end

defmodule Lightnex.LNRPC.WalletKit.FinalizePsbtResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :signed_psbt, 1, type: :bytes, json_name: "signedPsbt"
  field :raw_final_tx, 2, type: :bytes, json_name: "rawFinalTx"
end

defmodule Lightnex.LNRPC.WalletKit.ListLeasesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.WalletKit.ListLeasesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :locked_utxos, 1,
    repeated: true,
    type: Lightnex.LNRPC.WalletKit.UtxoLease,
    json_name: "lockedUtxos"
end

defmodule Lightnex.LNRPC.WalletKit.Service do
  @moduledoc """
  WalletKit is a service that gives access to the core functionalities of the
  daemon's wallet.
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

  use GRPC.Service, name: "walletrpc.WalletKit", protoc_gen_elixir_version: "0.15.0"

  rpc :ListUnspent,
      Lightnex.LNRPC.WalletKit.ListUnspentRequest,
      Lightnex.LNRPC.WalletKit.ListUnspentResponse

  rpc :LeaseOutput,
      Lightnex.LNRPC.WalletKit.LeaseOutputRequest,
      Lightnex.LNRPC.WalletKit.LeaseOutputResponse

  rpc :ReleaseOutput,
      Lightnex.LNRPC.WalletKit.ReleaseOutputRequest,
      Lightnex.LNRPC.WalletKit.ReleaseOutputResponse

  rpc :ListLeases,
      Lightnex.LNRPC.WalletKit.ListLeasesRequest,
      Lightnex.LNRPC.WalletKit.ListLeasesResponse

  rpc :DeriveNextKey, Lightnex.LNRPC.WalletKit.KeyReq, Lightnex.LNRPC.Signer.KeyDescriptor

  rpc :DeriveKey, Lightnex.LNRPC.Signer.KeyLocator, Lightnex.LNRPC.Signer.KeyDescriptor

  rpc :NextAddr, Lightnex.LNRPC.WalletKit.AddrRequest, Lightnex.LNRPC.WalletKit.AddrResponse

  rpc :GetTransaction,
      Lightnex.LNRPC.WalletKit.GetTransactionRequest,
      Lightnex.LNRPC.Lightning.Transaction

  rpc :ListAccounts,
      Lightnex.LNRPC.WalletKit.ListAccountsRequest,
      Lightnex.LNRPC.WalletKit.ListAccountsResponse

  rpc :RequiredReserve,
      Lightnex.LNRPC.WalletKit.RequiredReserveRequest,
      Lightnex.LNRPC.WalletKit.RequiredReserveResponse

  rpc :ListAddresses,
      Lightnex.LNRPC.WalletKit.ListAddressesRequest,
      Lightnex.LNRPC.WalletKit.ListAddressesResponse

  rpc :SignMessageWithAddr,
      Lightnex.LNRPC.WalletKit.SignMessageWithAddrRequest,
      Lightnex.LNRPC.WalletKit.SignMessageWithAddrResponse

  rpc :VerifyMessageWithAddr,
      Lightnex.LNRPC.WalletKit.VerifyMessageWithAddrRequest,
      Lightnex.LNRPC.WalletKit.VerifyMessageWithAddrResponse

  rpc :ImportAccount,
      Lightnex.LNRPC.WalletKit.ImportAccountRequest,
      Lightnex.LNRPC.WalletKit.ImportAccountResponse

  rpc :ImportPublicKey,
      Lightnex.LNRPC.WalletKit.ImportPublicKeyRequest,
      Lightnex.LNRPC.WalletKit.ImportPublicKeyResponse

  rpc :ImportTapscript,
      Lightnex.LNRPC.WalletKit.ImportTapscriptRequest,
      Lightnex.LNRPC.WalletKit.ImportTapscriptResponse

  rpc :PublishTransaction,
      Lightnex.LNRPC.WalletKit.Transaction,
      Lightnex.LNRPC.WalletKit.PublishResponse

  rpc :RemoveTransaction,
      Lightnex.LNRPC.WalletKit.GetTransactionRequest,
      Lightnex.LNRPC.WalletKit.RemoveTransactionResponse

  rpc :SendOutputs,
      Lightnex.LNRPC.WalletKit.SendOutputsRequest,
      Lightnex.LNRPC.WalletKit.SendOutputsResponse

  rpc :EstimateFee,
      Lightnex.LNRPC.WalletKit.EstimateFeeRequest,
      Lightnex.LNRPC.WalletKit.EstimateFeeResponse

  rpc :PendingSweeps,
      Lightnex.LNRPC.WalletKit.PendingSweepsRequest,
      Lightnex.LNRPC.WalletKit.PendingSweepsResponse

  rpc :BumpFee, Lightnex.LNRPC.WalletKit.BumpFeeRequest, Lightnex.LNRPC.WalletKit.BumpFeeResponse

  rpc :BumpForceCloseFee,
      Lightnex.LNRPC.WalletKit.BumpForceCloseFeeRequest,
      Lightnex.LNRPC.WalletKit.BumpForceCloseFeeResponse

  rpc :ListSweeps,
      Lightnex.LNRPC.WalletKit.ListSweepsRequest,
      Lightnex.LNRPC.WalletKit.ListSweepsResponse

  rpc :LabelTransaction,
      Lightnex.LNRPC.WalletKit.LabelTransactionRequest,
      Lightnex.LNRPC.WalletKit.LabelTransactionResponse

  rpc :FundPsbt,
      Lightnex.LNRPC.WalletKit.FundPsbtRequest,
      Lightnex.LNRPC.WalletKit.FundPsbtResponse

  rpc :SignPsbt,
      Lightnex.LNRPC.WalletKit.SignPsbtRequest,
      Lightnex.LNRPC.WalletKit.SignPsbtResponse

  rpc :FinalizePsbt,
      Lightnex.LNRPC.WalletKit.FinalizePsbtRequest,
      Lightnex.LNRPC.WalletKit.FinalizePsbtResponse
end

defmodule Lightnex.LNRPC.WalletKit.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.WalletKit.Service
end
