defmodule Lightnex.Conn.NodeInfo do
  @moduledoc """
  Node information returned from `Lightnex.get_info/1`.

  This struct contains identifying information and current state about an
  LND node.
  """

  @typedoc """
  Blockchain chain information.
  """
  @type chain :: %{
          chain: String.t(),
          network: String.t()
        }

  @typedoc """
  Node information struct.
  """
  @type t :: %__MODULE__{
          identity_pubkey: String.t(),
          alias: String.t(),
          num_active_channels: non_neg_integer(),
          num_peers: non_neg_integer(),
          block_height: non_neg_integer(),
          synced_to_chain: boolean(),
          synced_to_graph: boolean(),
          version: String.t(),
          chains: [chain()]
        }

  @enforce_keys [
    :identity_pubkey,
    :alias,
    :num_active_channels,
    :num_peers,
    :block_height,
    :synced_to_chain,
    :synced_to_graph,
    :version,
    :chains
  ]

  defstruct [
    :identity_pubkey,
    :alias,
    :num_active_channels,
    :num_peers,
    :block_height,
    :synced_to_chain,
    :synced_to_graph,
    :version,
    :chains
  ]

  @doc """
  Creates a new NodeInfo struct from a GetInfoResponse.

  ## Examples

      iex> response = %Lightning.GetInfoResponse{...}
      iex> Lightnex.Conn.NodeInfo.new(response)
      %Lightnex.Conn.NodeInfo{
        identity_pubkey: "02abc...",
        alias: "my-node",
        ...
      }

  """
  @spec new(map() | keyword()) :: t()
  def new(response) do
    struct(__MODULE__, Enum.into(response, %{}))
  end
end
