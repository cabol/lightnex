defmodule LightnexTest do
  use ExUnit.Case, async: false
  use Mimic

  import Lightnex.LightningFixtures

  alias Lightnex.Conn
  alias Lightnex.LNRPC.Lightning

  @address "localhost:10009"

  describe "connect/2" do
    setup :verify_on_exit!

    test "successful connection without macaroon" do
      mock_channel = grpc_channel()

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      assert {:ok, %Conn{} = conn} = Lightnex.connect(@address, validate: false)
      assert conn.channel == mock_channel
      assert conn.address == @address
      assert conn.macaroon_hex == nil
      refute Conn.authenticated?(conn)
    end

    test "successful connection with file macaroon" do
      mock_channel = grpc_channel()
      macaroon_binary = binary_macaroon()
      macaroon_hex = valid_macaroon_hex()

      File
      |> expect(:read, fn "/path/to/macaroon" ->
        {:ok, macaroon_binary}
      end)

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      opts = [
        macaroon: "/path/to/macaroon",
        macaroon_type: :file,
        validate: false
      ]

      assert {:ok, %Conn{} = conn} = Lightnex.connect(@address, opts)
      assert conn.macaroon_hex == String.downcase(macaroon_hex)
      assert Conn.authenticated?(conn)
    end

    test "successful connection with hex macaroon" do
      mock_channel = grpc_channel()
      macaroon_hex = valid_macaroon_hex()

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      opts = [
        macaroon: macaroon_hex,
        macaroon_type: :hex,
        validate: false
      ]

      assert {:ok, %Conn{} = conn} = Lightnex.connect(@address, opts)
      assert conn.macaroon_hex == String.downcase(macaroon_hex)
      assert Conn.authenticated?(conn)
    end

    test "successful connection with binary macaroon" do
      mock_channel = grpc_channel()
      macaroon_binary = binary_macaroon()
      expected_hex = valid_macaroon_hex()

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      opts = [
        macaroon: macaroon_binary,
        macaroon_type: :bin,
        validate: false
      ]

      assert {:ok, %Conn{} = conn} = Lightnex.connect(@address, opts)
      assert conn.macaroon_hex == expected_hex
      assert Conn.authenticated?(conn)
    end

    test "connection with validation calls get_info" do
      mock_channel = grpc_channel()
      get_info_response = get_info_response(alias: "test-node")

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      Lightning.Stub
      |> expect(:get_info, fn ^mock_channel, %Lightning.GetInfoRequest{}, metadata: [] ->
        {:ok, get_info_response}
      end)

      assert {:ok, %Conn{} = conn} = Lightnex.connect(@address, validate: true)
      assert conn.node_info.alias == "test-node"
      assert conn.node_info.identity_pubkey == get_info_response.identity_pubkey
    end

    test "connection fails when grpc connection fails" do
      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:error, :connection_refused}
      end)

      assert Lightnex.connect(@address, validate: false) == {:error, :connection_refused}
    end

    test "connection fails when macaroon file doesn't exist" do
      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, grpc_channel()}
      end)

      File
      |> expect(:read, fn "/nonexistent/macaroon" ->
        {:error, :enoent}
      end)

      opts = [
        macaroon: "/nonexistent/macaroon",
        macaroon_type: :file,
        validate: false
      ]

      assert Lightnex.connect(@address, opts) == {:error, :enoent}
    end

    test "connection fails when hex macaroon is invalid" do
      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, grpc_channel()}
      end)

      opts = [
        macaroon: invalid_macaroon_hex(),
        macaroon_type: :hex,
        validate: false
      ]

      assert Lightnex.connect(@address, opts) == {:error, :invalid_hex_format}
    end

    test "connection fails when validation fails" do
      mock_channel = grpc_channel()

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      Lightning.Stub
      |> expect(:get_info, fn ^mock_channel, %Lightning.GetInfoRequest{}, metadata: [] ->
        grpc_error(:permission_denied)
      end)

      assert {:error, %GRPC.RPCError{status: 7, message: "permission denied"}} =
               Lightnex.connect(@address, validate: true)
    end
  end

  describe "get_info/1" do
    setup :verify_on_exit!

    test "successful get_info call" do
      conn = authenticated_connection()
      get_info_response = get_info_response()
      macaroon = conn.macaroon_hex

      Lightning.Stub
      |> expect(:get_info, fn %GRPC.Channel{},
                              %Lightning.GetInfoRequest{},
                              metadata: %{macaroon: ^macaroon} ->
        {:ok, get_info_response}
      end)

      assert {:ok, info} = Lightnex.get_info(conn)
      assert info.identity_pubkey == get_info_response.identity_pubkey
      assert info.alias == get_info_response.alias
      assert info.num_active_channels == get_info_response.num_active_channels
      assert info.synced_to_chain == get_info_response.synced_to_chain
    end

    test "get_info with no macaroon" do
      conn = connection()
      get_info_response = get_info_response()

      Lightning.Stub
      |> expect(:get_info, fn _conn, %Lightning.GetInfoRequest{}, metadata: [] ->
        {:ok, get_info_response}
      end)

      assert {:ok, _info} = Lightnex.get_info(conn)
    end

    test "get_info fails with error" do
      conn = connection()

      Lightning.Stub
      |> expect(:get_info, fn _conn, %Lightning.GetInfoRequest{}, metadata: [] ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14, message: "unavailable"}} =
               Lightnex.get_info(conn)
    end
  end

  describe "disconnect/1" do
    setup :verify_on_exit!

    test "successful disconnect" do
      conn = connection()

      GRPC.Stub
      |> expect(:disconnect, fn _conn ->
        {:ok, nil}
      end)

      assert {:ok, nil} = Lightnex.disconnect(conn)
    end
  end
end
