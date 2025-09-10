defmodule Lightnex do
  @moduledoc """
  Documentation for `Lightnex`.
  """

  ## API

  @doc """
  Connects to a LND node.

  Wrapper for `GRPC.Stub.connect/2`.

  ## Options

  Same as `GRPC.Stub.connect/2`.

  ## Examples

      iex> {:ok, channel} = Lightnex.connect("localhost:10009")
      #=> {:ok, %GRPC.Channel{...}}

      iex> cred = GRPC.Credential.new(ssl: [
      ...>   cacertfile: "path/to/cacert.pem",
      ...>   verify: :verify_none
      ...> ])
      iex> {:ok, channel} = Lightnex.connect("localhost:10009", cred: cred)
      #=> {:ok, %GRPC.Channel{...}}

  """
  defdelegate connect(address, opts \\ []), to: GRPC.Stub

  @doc """
  Wrapper for `GRPC.Stub.connect/3`.
  """
  defdelegate connect(host, port, opts), to: GRPC.Stub

  @doc """
  Wrapper for `GRPC.Stub.disconnect/1`.

  ## Examples

      iex> Lightnex.disconnect(channel)
      #=> {:ok, %GRPC.Channel{...}}

  """
  defdelegate disconnect(channel), to: GRPC.Stub
end
