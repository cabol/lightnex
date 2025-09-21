defmodule Lightnex.LNRPC.Signer.SignMethod do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :SIGN_METHOD_WITNESS_V0, 0
  field :SIGN_METHOD_TAPROOT_KEY_SPEND_BIP0086, 1
  field :SIGN_METHOD_TAPROOT_KEY_SPEND, 2
  field :SIGN_METHOD_TAPROOT_SCRIPT_SPEND, 3
end

defmodule Lightnex.LNRPC.Signer.MuSig2Version do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :MUSIG2_VERSION_UNDEFINED, 0
  field :MUSIG2_VERSION_V040, 1
  field :MUSIG2_VERSION_V100RC2, 2
end

defmodule Lightnex.LNRPC.Signer.KeyLocator do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key_family, 1, type: :int32, json_name: "keyFamily"
  field :key_index, 2, type: :int32, json_name: "keyIndex"
end

defmodule Lightnex.LNRPC.Signer.KeyDescriptor do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_key_bytes, 1, type: :bytes, json_name: "rawKeyBytes"
  field :key_loc, 2, type: Lightnex.LNRPC.Signer.KeyLocator, json_name: "keyLoc"
end

defmodule Lightnex.LNRPC.Signer.TxOut do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :value, 1, type: :int64
  field :pk_script, 2, type: :bytes, json_name: "pkScript"
end

defmodule Lightnex.LNRPC.Signer.SignDescriptor do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key_desc, 1, type: Lightnex.LNRPC.Signer.KeyDescriptor, json_name: "keyDesc"
  field :single_tweak, 2, type: :bytes, json_name: "singleTweak"
  field :double_tweak, 3, type: :bytes, json_name: "doubleTweak"
  field :tap_tweak, 10, type: :bytes, json_name: "tapTweak"
  field :witness_script, 4, type: :bytes, json_name: "witnessScript"
  field :output, 5, type: Lightnex.LNRPC.Signer.TxOut
  field :sighash, 7, type: :uint32
  field :input_index, 8, type: :int32, json_name: "inputIndex"

  field :sign_method, 9,
    type: Lightnex.LNRPC.Signer.SignMethod,
    json_name: "signMethod",
    enum: true
end

defmodule Lightnex.LNRPC.Signer.SignReq do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_tx_bytes, 1, type: :bytes, json_name: "rawTxBytes"

  field :sign_descs, 2,
    repeated: true,
    type: Lightnex.LNRPC.Signer.SignDescriptor,
    json_name: "signDescs"

  field :prev_outputs, 3,
    repeated: true,
    type: Lightnex.LNRPC.Signer.TxOut,
    json_name: "prevOutputs"
end

defmodule Lightnex.LNRPC.Signer.SignResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :raw_sigs, 1, repeated: true, type: :bytes, json_name: "rawSigs"
end

defmodule Lightnex.LNRPC.Signer.InputScript do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :witness, 1, repeated: true, type: :bytes
  field :sig_script, 2, type: :bytes, json_name: "sigScript"
end

defmodule Lightnex.LNRPC.Signer.InputScriptResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :input_scripts, 1,
    repeated: true,
    type: Lightnex.LNRPC.Signer.InputScript,
    json_name: "inputScripts"
end

defmodule Lightnex.LNRPC.Signer.SignMessageReq do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :msg, 1, type: :bytes
  field :key_loc, 2, type: Lightnex.LNRPC.Signer.KeyLocator, json_name: "keyLoc"
  field :double_hash, 3, type: :bool, json_name: "doubleHash"
  field :compact_sig, 4, type: :bool, json_name: "compactSig"
  field :schnorr_sig, 5, type: :bool, json_name: "schnorrSig"
  field :schnorr_sig_tap_tweak, 6, type: :bytes, json_name: "schnorrSigTapTweak"
  field :tag, 7, type: :bytes
end

defmodule Lightnex.LNRPC.Signer.SignMessageResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :signature, 1, type: :bytes
end

defmodule Lightnex.LNRPC.Signer.VerifyMessageReq do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :msg, 1, type: :bytes
  field :signature, 2, type: :bytes
  field :pubkey, 3, type: :bytes
  field :is_schnorr_sig, 4, type: :bool, json_name: "isSchnorrSig"
  field :tag, 5, type: :bytes
end

defmodule Lightnex.LNRPC.Signer.VerifyMessageResp do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :valid, 1, type: :bool
end

defmodule Lightnex.LNRPC.Signer.SharedKeyRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :ephemeral_pubkey, 1, type: :bytes, json_name: "ephemeralPubkey"
  field :key_loc, 2, type: Lightnex.LNRPC.Signer.KeyLocator, json_name: "keyLoc", deprecated: true
  field :key_desc, 3, type: Lightnex.LNRPC.Signer.KeyDescriptor, json_name: "keyDesc"
end

defmodule Lightnex.LNRPC.Signer.SharedKeyResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :shared_key, 1, type: :bytes, json_name: "sharedKey"
end

defmodule Lightnex.LNRPC.Signer.TweakDesc do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :tweak, 1, type: :bytes
  field :is_x_only, 2, type: :bool, json_name: "isXOnly"
end

defmodule Lightnex.LNRPC.Signer.TaprootTweakDesc do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :script_root, 1, type: :bytes, json_name: "scriptRoot"
  field :key_spend_only, 2, type: :bool, json_name: "keySpendOnly"
end

defmodule Lightnex.LNRPC.Signer.MuSig2CombineKeysRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :all_signer_pubkeys, 1, repeated: true, type: :bytes, json_name: "allSignerPubkeys"
  field :tweaks, 2, repeated: true, type: Lightnex.LNRPC.Signer.TweakDesc
  field :taproot_tweak, 3, type: Lightnex.LNRPC.Signer.TaprootTweakDesc, json_name: "taprootTweak"
  field :version, 4, type: Lightnex.LNRPC.Signer.MuSig2Version, enum: true
end

defmodule Lightnex.LNRPC.Signer.MuSig2CombineKeysResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :combined_key, 1, type: :bytes, json_name: "combinedKey"
  field :taproot_internal_key, 2, type: :bytes, json_name: "taprootInternalKey"
  field :version, 4, type: Lightnex.LNRPC.Signer.MuSig2Version, enum: true
end

defmodule Lightnex.LNRPC.Signer.MuSig2SessionRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :key_loc, 1, type: Lightnex.LNRPC.Signer.KeyLocator, json_name: "keyLoc"
  field :all_signer_pubkeys, 2, repeated: true, type: :bytes, json_name: "allSignerPubkeys"

  field :other_signer_public_nonces, 3,
    repeated: true,
    type: :bytes,
    json_name: "otherSignerPublicNonces"

  field :tweaks, 4, repeated: true, type: Lightnex.LNRPC.Signer.TweakDesc
  field :taproot_tweak, 5, type: Lightnex.LNRPC.Signer.TaprootTweakDesc, json_name: "taprootTweak"
  field :version, 6, type: Lightnex.LNRPC.Signer.MuSig2Version, enum: true
  field :pregenerated_local_nonce, 7, type: :bytes, json_name: "pregeneratedLocalNonce"
end

defmodule Lightnex.LNRPC.Signer.MuSig2SessionResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :session_id, 1, type: :bytes, json_name: "sessionId"
  field :combined_key, 2, type: :bytes, json_name: "combinedKey"
  field :taproot_internal_key, 3, type: :bytes, json_name: "taprootInternalKey"
  field :local_public_nonces, 4, type: :bytes, json_name: "localPublicNonces"
  field :have_all_nonces, 5, type: :bool, json_name: "haveAllNonces"
  field :version, 6, type: Lightnex.LNRPC.Signer.MuSig2Version, enum: true
end

defmodule Lightnex.LNRPC.Signer.MuSig2RegisterNoncesRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :session_id, 1, type: :bytes, json_name: "sessionId"

  field :other_signer_public_nonces, 3,
    repeated: true,
    type: :bytes,
    json_name: "otherSignerPublicNonces"
end

defmodule Lightnex.LNRPC.Signer.MuSig2RegisterNoncesResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :have_all_nonces, 1, type: :bool, json_name: "haveAllNonces"
end

defmodule Lightnex.LNRPC.Signer.MuSig2SignRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :session_id, 1, type: :bytes, json_name: "sessionId"
  field :message_digest, 2, type: :bytes, json_name: "messageDigest"
  field :cleanup, 3, type: :bool
end

defmodule Lightnex.LNRPC.Signer.MuSig2SignResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :local_partial_signature, 1, type: :bytes, json_name: "localPartialSignature"
end

defmodule Lightnex.LNRPC.Signer.MuSig2CombineSigRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :session_id, 1, type: :bytes, json_name: "sessionId"

  field :other_partial_signatures, 2,
    repeated: true,
    type: :bytes,
    json_name: "otherPartialSignatures"
end

defmodule Lightnex.LNRPC.Signer.MuSig2CombineSigResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :have_all_signatures, 1, type: :bool, json_name: "haveAllSignatures"
  field :final_signature, 2, type: :bytes, json_name: "finalSignature"
end

defmodule Lightnex.LNRPC.Signer.MuSig2CleanupRequest do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :session_id, 1, type: :bytes, json_name: "sessionId"
end

defmodule Lightnex.LNRPC.Signer.MuSig2CleanupResponse do
  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Lightnex.LNRPC.Signer.Service do
  @moduledoc """
  Signer is a service that gives access to the signing functionality of the
  daemon's wallet.
  """

  use GRPC.Service, name: "signrpc.Signer", protoc_gen_elixir_version: "0.15.0"

  rpc :SignOutputRaw, Lightnex.LNRPC.Signer.SignReq, Lightnex.LNRPC.Signer.SignResp

  rpc :ComputeInputScript, Lightnex.LNRPC.Signer.SignReq, Lightnex.LNRPC.Signer.InputScriptResp

  rpc :SignMessage, Lightnex.LNRPC.Signer.SignMessageReq, Lightnex.LNRPC.Signer.SignMessageResp

  rpc :VerifyMessage,
      Lightnex.LNRPC.Signer.VerifyMessageReq,
      Lightnex.LNRPC.Signer.VerifyMessageResp

  rpc :DeriveSharedKey,
      Lightnex.LNRPC.Signer.SharedKeyRequest,
      Lightnex.LNRPC.Signer.SharedKeyResponse

  rpc :MuSig2CombineKeys,
      Lightnex.LNRPC.Signer.MuSig2CombineKeysRequest,
      Lightnex.LNRPC.Signer.MuSig2CombineKeysResponse

  rpc :MuSig2CreateSession,
      Lightnex.LNRPC.Signer.MuSig2SessionRequest,
      Lightnex.LNRPC.Signer.MuSig2SessionResponse

  rpc :MuSig2RegisterNonces,
      Lightnex.LNRPC.Signer.MuSig2RegisterNoncesRequest,
      Lightnex.LNRPC.Signer.MuSig2RegisterNoncesResponse

  rpc :MuSig2Sign,
      Lightnex.LNRPC.Signer.MuSig2SignRequest,
      Lightnex.LNRPC.Signer.MuSig2SignResponse

  rpc :MuSig2CombineSig,
      Lightnex.LNRPC.Signer.MuSig2CombineSigRequest,
      Lightnex.LNRPC.Signer.MuSig2CombineSigResponse

  rpc :MuSig2Cleanup,
      Lightnex.LNRPC.Signer.MuSig2CleanupRequest,
      Lightnex.LNRPC.Signer.MuSig2CleanupResponse
end

defmodule Lightnex.LNRPC.Signer.Stub do
  use GRPC.Stub, service: Lightnex.LNRPC.Signer.Service
end
