defmodule Mix.Lightnex do
  @moduledoc """
  Mix tasks for Lightnex.
  """

  # Protobuf files
  @proto_files [
    "lightning.proto",
    "stateservice.proto",
    "walletunlocker.proto",
    "chainrpc/chainnotifier.proto",
    "chainrpc/chainkit.proto",
    "invoicesrpc/invoices.proto",
    "peersrpc/peers.proto",
    "routerrpc/router.proto",
    "signrpc/signer.proto",
    "walletrpc/walletkit.proto",
    "watchtowerrpc/watchtower.proto",
    "wtclientrpc/wtclient.proto"
  ]

  ## API

  @doc """
  Returns the list of protobuf files.
  """
  @spec proto_files() :: [String.t()]
  def proto_files, do: @proto_files

  @doc """
  Formats the code.
  """
  @spec format_code() :: :ok
  def format_code(inputs \\ ["lib/lightnex/lnrpc/**/*.ex"]) do
    Mix.Tasks.Format.run(inputs)
  end
end
