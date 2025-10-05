defmodule Lightnex.Conn do
  @moduledoc """
  Connection abstraction for LND gRPC communication.

  This struct holds all necessary information for authenticated communication
  with an LND node, including the gRPC channel, macaroon for authentication,
  and connection metadata.

  ## Fields

    * `:channel` - The underlying gRPC channel
    * `:macaroon_hex` - Hex-encoded macaroon for authentication
    * `:timeout` - Request timeout in milliseconds
    * `:address` - LND node address (e.g., "localhost:10009")
    * `:node_info` - Node information from `get_info` (if validated)
    * `:connected_at` - Connection timestamp

  ## Examples

      # Create connection
      {:ok, channel} = GRPC.Stub.connect("localhost:10009")
      {:ok, conn} = Lightnex.Conn.new(channel,
        address: "localhost:10009",
        macaroon: "~/.lnd/admin.macaroon"
      )

      # Check authentication
      Lightnex.Conn.authenticated?(conn)
      #=> true

      # Get connection summary
      Lightnex.Conn.summary(conn)
      #=> %{address: "localhost:10009", authenticated: true, ...}

  """

  alias Lightnex.Conn.NodeInfo

  ## Types & Schemas

  @typedoc "Type of macaroon to extract"
  @type macaroon_type() :: :file | :hex | :bin

  @typedoc "Connection struct"
  @type t() :: %__MODULE__{
          channel: GRPC.Channel.t(),
          macaroon_hex: String.t() | nil,
          timeout: non_neg_integer(),
          address: String.t(),
          node_info: NodeInfo.t() | nil,
          connected_at: DateTime.t()
        }

  defstruct [
    :channel,
    :macaroon_hex,
    :timeout,
    :address,
    :node_info,
    :connected_at
  ]

  # Connection options
  conn_opts = [
    macaroon: [
      type: :string,
      required: false,
      doc: """
      The macaroon to use for authentication. The given string will be converted
      to hex if it is not already. See `:macaroon_type` option for the type of
      macaroon to use.
      """
    ],
    macaroon_type: [
      type: {:in, [:file, :hex, :bin]},
      required: false,
      default: :file,
      doc: """
      The type of macaroon to use for authentication.
      """
    ],
    timeout: [
      type: :integer,
      required: false,
      default: :timer.seconds(30),
      doc: """
      The timeout to use for the connection.
      """
    ],
    address: [
      type: :string,
      required: true,
      default: "localhost:10009",
      doc: """
      The address to use for the connection.
      """
    ],
    node_info: [
      type: {:or, [:any, nil]},
      required: false,
      default: nil,
      doc: """
      The node information to use for the connection.
      """
    ]
  ]

  # Connection options schema
  @conn_opts_schema NimbleOptions.new!(conn_opts)

  # Connection options
  @conn_opts Keyword.keys(@conn_opts_schema.schema)

  ## API

  # Inline common instructions.
  @compile {:inline, conn_opts: 0}

  @doc """
  Returns the connection options.
  """
  @spec conn_opts() :: [atom()]
  def conn_opts, do: @conn_opts

  # coveralls-ignore-start

  @doc """
  Returns the connection options documentation.
  """
  @spec conn_opts_docs() :: String.t()
  def conn_opts_docs do
    NimbleOptions.docs(@conn_opts_schema)
  end

  # coveralls-ignore-stop

  @doc """
  Creates a new Lightnex connection struct.

  ## Options

  #{NimbleOptions.docs(@conn_opts_schema)}

  ## Examples

      iex> Lightnex.Conn.new(channel, macaroon: "path/to/macaroon")
      #=> {:ok, %Lightnex.Conn{...}}

  """
  @spec new(GRPC.Channel.t(), keyword()) :: {:ok, t()} | {:error, any()}
  def new(channel, opts \\ []) do
    opts = NimbleOptions.validate!(opts, @conn_opts_schema)
    macaroon = Keyword.get(opts, :macaroon)
    macaroon_type = Keyword.get(opts, :macaroon_type)

    with {:ok, macaroon_hex} <- extract_macaroon(macaroon, macaroon_type) do
      {:ok,
       %__MODULE__{
         channel: channel,
         macaroon_hex: macaroon_hex,
         timeout: Keyword.fetch!(opts, :timeout),
         address: Keyword.fetch!(opts, :address),
         node_info: Keyword.fetch!(opts, :node_info),
         connected_at: DateTime.utc_now()
       }}
    end
  end

  @doc """
  Creates a new Lightnex connection struct.

  Raises on error.

  ## Examples

      iex> Lightnex.Conn.new!(channel, macaroon: "path/to/macaroon")
      #=> %Lightnex.Conn{...}

  """
  @spec new!(GRPC.Channel.t(), keyword()) :: t()
  def new!(channel, opts \\ []) do
    case new(channel, opts) do
      {:ok, conn} ->
        conn

      {:error, reason} ->
        raise "macaroon error: #{inspect(reason)}"
    end
  end

  @doc """
  Extracts macaroon from various input formats and converts to hex.

  ## Parameters

    * `macaroon` - Macaroon in various formats (file path, hex string, or binary)
    * `type` - Format type (`:file`, `:hex`, or `:bin`)

  ## Examples

      # From file
      {:ok, hex} = Lightnex.Conn.extract_macaroon("/path/to/macaroon", :file)

      # From hex string
      {:ok, hex} = Lightnex.Conn.extract_macaroon("0201036c6e64...", :hex)

      # From binary
      {:ok, hex} = Lightnex.Conn.extract_macaroon(<<2, 1, 3, ...>>, :bin)

  """
  @spec extract_macaroon(String.t() | binary() | nil, macaroon_type() | nil) ::
          {:ok, String.t() | nil} | {:error, any()}
  def extract_macaroon(macaroon, type)

  # sobelow_skip ["Traversal.FileModule"]
  def extract_macaroon(file_path, :file) when is_binary(file_path) do
    with {:ok, binary} <- File.read(file_path) do
      {:ok, Base.encode16(binary, case: :lower)}
    end
  end

  def extract_macaroon(hex_string, :hex) when is_binary(hex_string) do
    # Validate hex format
    case Base.decode16(hex_string, case: :mixed) do
      {:ok, _bin} -> {:ok, String.downcase(hex_string)}
      :error -> {:error, :invalid_hex_format}
    end
  end

  def extract_macaroon(binary, :bin) when is_binary(binary) do
    {:ok, Base.encode16(binary, case: :lower)}
  end

  def extract_macaroon(nil, _type) do
    {:ok, nil}
  end

  @doc """
  Gets gRPC metadata headers including macaroon authentication.

  Returns a map with the macaroon header if authenticated, or an empty
  map if no authentication is configured.

  ## Examples

      iex> Lightnex.Conn.grpc_metadata(conn)
      %{macaroon: "0201036c6e64..."}

      iex> Lightnex.Conn.grpc_metadata(unauthenticated_conn)
      %{}

  """
  @spec grpc_metadata(t()) :: map()
  def grpc_metadata(conn)

  def grpc_metadata(%__MODULE__{macaroon_hex: nil}) do
    %{}
  end

  def grpc_metadata(%__MODULE__{macaroon_hex: macaroon_hex}) do
    %{macaroon: macaroon_hex}
  end

  @doc """
  Updates the connection with node information.

  Typically called after `Lightnex.get_info/1` to populate node details.

  ## Examples

      {:ok, info} = Lightnex.get_info(conn)
      conn = Lightnex.Conn.put_node_info(conn, info)

  """
  @spec put_node_info(t(), NodeInfo.t() | map()) :: t()
  def put_node_info(conn, node_info)

  def put_node_info(%__MODULE__{} = conn, %NodeInfo{} = node_info) do
    %{conn | node_info: node_info}
  end

  def put_node_info(%__MODULE__{} = conn, %{} = node_info) do
    put_node_info(conn, struct(NodeInfo, node_info))
  end

  @doc """
  Checks if the connection is authenticated (has macaroon).

  ## Examples

      iex> Lightnex.Conn.authenticated?(conn)
      true

      iex> Lightnex.Conn.authenticated?(unauthenticated_conn)
      false

  """
  @spec authenticated?(t()) :: boolean()
  def authenticated?(conn)

  def authenticated?(%__MODULE__{macaroon_hex: nil}), do: false
  def authenticated?(%__MODULE__{macaroon_hex: _}), do: true

  @doc """
  Returns connection summary for logging/debugging.

  ## Examples

      iex> Lightnex.Conn.summary(conn)
      %{
        address: "localhost:10009",
        authenticated: true,
        timeout: 30000,
        connected_at: ~U[2024-01-01 00:00:00Z],
        node_alias: "alice",
        node_pubkey: "02abc..."
      }

  """
  @spec summary(t()) :: map()
  def summary(%__MODULE__{} = conn) do
    %{
      address: conn.address,
      authenticated: authenticated?(conn),
      timeout: conn.timeout,
      connected_at: conn.connected_at,
      node_alias: node_alias(conn.node_info),
      node_pubkey: node_pubkey(conn.node_info)
    }
  end

  ## Private helpers

  defp node_alias(nil), do: nil
  defp node_alias(%NodeInfo{alias: alias}), do: alias

  defp node_pubkey(nil), do: nil
  defp node_pubkey(%NodeInfo{identity_pubkey: pubkey}), do: pubkey
end
