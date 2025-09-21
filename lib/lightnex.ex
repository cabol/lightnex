defmodule Lightnex do
  @moduledoc """
  Documentation for `Lightnex`.
  """

  alias Lightnex.Conn
  alias Lightnex.LNRPC.Lightning

  ## API

  @doc """
  Connects to a LND node with authentication support.

  ## Options

  #{Conn.conn_opts_docs()}

  > #### Connection options {: .info}
  >
  > `GRPC.Stub.connect/2` options are supported.

  ## Examples

      # Simple local connection (regtest, no auth)
      iex> {:ok, conn} = Lightnex.connect("localhost:10009")

      # Authenticated connection with macaroon file
      iex> {:ok, conn} = Lightnex.connect("localhost:10009",
      ...>   cred: GRPC.Credential.new(ssl: [cacertfile: "~/.lnd/tls.cert"]),
      ...>   macaroon: "~/.lnd/data/chain/bitcoin/regtest/admin.macaroon"
      ...> )

      # Connection with hex macaroon
      iex> {:ok, conn} = Lightnex.connect("localhost:10009",
      ...>   macaroon: "0201036c6e64...",
      ...>   macaroon_type: :hex
      ...> )

  """
  @spec connect(String.t(), keyword()) :: {:ok, Conn.t()} | {:error, term()}
  def connect(address, opts \\ []) when is_binary(address) and is_list(opts) do
    {conn_opts, opts} = Keyword.split(opts, Conn.conn_opts())
    {should_validate?, opts} = Keyword.pop(opts, :validate, true)

    with {:ok, channel} <- GRPC.Stub.connect(address, opts),
         {:ok, conn} <- Conn.new(channel, [address: address] ++ conn_opts) do
      maybe_validate_conn(conn, should_validate?)
    end
  end

  @doc """
  Gets basic information about the LND node.
  """
  @spec get_info(Conn.t()) :: {:ok, Lightning.GetInfoResponse.t()} | {:error, any()}
  def get_info(%Conn{} = conn) do
    request = %Lightning.GetInfoRequest{}
    metadata = Conn.grpc_metadata(conn)

    with {:ok, response} <- Lightning.Stub.get_info(conn.channel, request, metadata: metadata) do
      info = %{
        identity_pubkey: response.identity_pubkey,
        alias: response.alias,
        num_active_channels: response.num_active_channels,
        num_peers: response.num_peers,
        block_height: response.block_height,
        synced_to_chain: response.synced_to_chain,
        synced_to_graph: response.synced_to_graph,
        version: response.version,
        chains: Enum.map(response.chains, &chain_to_map/1)
      }

      {:ok, info}
    end
  end

  @doc """
  Wrapper for `GRPC.Stub.disconnect/1`.

  ## Examples

      iex> Lightnex.disconnect(conn)
      #=> {:ok, %GRPC.Channel{...}}

  """
  @spec disconnect(Conn.t()) :: {:ok, GRPC.Channel.t()} | {:error, any()}
  def disconnect(%Conn{channel: channel}) do
    GRPC.Stub.disconnect(channel)
  end

  # Private functions

  defp maybe_validate_conn(conn, false) do
    {:ok, conn}
  end

  defp maybe_validate_conn(conn, true) do
    with {:ok, info} <- get_info(conn) do
      {:ok, Conn.put_node_info(conn, info)}
    end
  end

  defp chain_to_map(chain) do
    %{
      chain: chain.chain,
      network: chain.network
    }
  end
end
