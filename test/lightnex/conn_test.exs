defmodule Lightnex.ConnTest do
  use ExUnit.Case, async: true
  import Mimic

  alias Lightnex.Conn

  @port 10_009

  describe "new!/2" do
    test "creates connection with default values" do
      channel = %GRPC.Channel{host: "localhost", port: @port}

      conn =
        Conn.new!(channel, address: "localhost:10009", macaroon: "abc123", macaroon_type: :hex)

      assert %Conn{} = conn
      assert conn.channel == channel
      assert conn.macaroon_hex == "abc123"
      assert conn.timeout == 30_000
      assert conn.address == "localhost:10009"
      assert %DateTime{} = conn.connected_at
    end

    test "creates connection with custom timeout" do
      channel = %GRPC.Channel{host: "localhost", port: @port}

      conn =
        Conn.new!(channel,
          address: "localhost:10009",
          macaroon: "abc123",
          macaroon_type: :hex,
          timeout: 60_000
        )

      assert conn.timeout == 60_000
    end

    test "creates connection with node info" do
      channel = %GRPC.Channel{host: "localhost", port: @port}
      node_info = %{alias: "alice", identity_pubkey: "02abc123"}

      conn =
        Conn.new!(channel,
          address: "localhost:10009",
          node_info: node_info
        )

      assert conn.node_info == node_info
    end

    test "handles file read error" do
      channel = %GRPC.Channel{host: "localhost", port: @port}

      file_path = "/nonexistent/file"

      File
      |> expect(:read, fn ^file_path ->
        {:error, :enoent}
      end)

      assert_raise RuntimeError, ~r/macaroon error/, fn ->
        Conn.new!(channel,
          address: "localhost:#{@port}",
          macaroon: file_path,
          macaroon_type: :file
        )
      end
    end
  end

  describe "conn_opts/0" do
    test "returns connection options" do
      assert Conn.conn_opts() |> Enum.sort() ==
               [:address, :macaroon, :macaroon_type, :timeout, :node_info] |> Enum.sort()
    end
  end

  describe "extract_macaroon/2" do
    setup :verify_on_exit!

    test "extracts macaroon from file" do
      file_path = "/path/to/macaroon"
      binary_content = <<1, 2, 3, 4, 5>>
      expected_hex = "0102030405"

      File
      |> expect(:read, fn ^file_path ->
        {:ok, binary_content}
      end)

      assert {:ok, hex} = Conn.extract_macaroon(file_path, :file)
      assert hex == expected_hex
    end

    test "handles file read error" do
      file_path = "/nonexistent/file"

      File
      |> expect(:read, fn ^file_path ->
        {:error, :enoent}
      end)

      assert Conn.extract_macaroon(file_path, :file) == {:error, :enoent}
    end

    test "extracts macaroon from valid hex string" do
      hex_string = "0201036c6e640247030a20"

      assert {:ok, result} = Conn.extract_macaroon(hex_string, :hex)
      assert result == String.downcase(hex_string)
    end

    test "extracts macaroon from uppercase hex string" do
      hex_string = "0201036C6E640247030A20"

      assert {:ok, result} = Conn.extract_macaroon(hex_string, :hex)
      assert result == String.downcase(hex_string)
    end

    test "rejects invalid hex string" do
      invalid_hex = "invalid_hex_string"

      assert {:error, :invalid_hex_format} = Conn.extract_macaroon(invalid_hex, :hex)
    end

    test "extracts macaroon from binary" do
      binary = <<1, 2, 3, 4, 5>>
      expected_hex = "0102030405"

      assert {:ok, hex} = Conn.extract_macaroon(binary, :bin)
      assert hex == expected_hex
    end

    test "handles nil macaroon" do
      assert Conn.extract_macaroon(nil, :file) == {:ok, nil}
      assert Conn.extract_macaroon(nil, :hex) == {:ok, nil}
      assert Conn.extract_macaroon(nil, :bin) == {:ok, nil}
    end
  end

  describe "grpc_metadata/1" do
    test "returns empty list when no macaroon" do
      conn = %Conn{macaroon_hex: nil}

      assert Conn.grpc_metadata(conn) == []
    end

    test "returns macaroon metadata when macaroon present" do
      conn = %Conn{macaroon_hex: "abc123"}

      assert Conn.grpc_metadata(conn) == %{macaroon: "abc123"}
    end
  end

  describe "put_node_info/2" do
    test "updates connection with node info" do
      channel = %GRPC.Channel{host: "localhost", port: @port}
      conn = Conn.new!(channel, address: "localhost:10009")

      node_info = %{alias: "alice", identity_pubkey: "02abc123"}
      updated_conn = Conn.put_node_info(conn, node_info)

      assert updated_conn.node_info == node_info
      # Other fields should remain unchanged
      assert updated_conn.channel == conn.channel
      assert updated_conn.address == conn.address
    end
  end

  describe "authenticated?/1" do
    test "returns false when no macaroon" do
      conn = %Conn{macaroon_hex: nil}

      refute Conn.authenticated?(conn)
    end

    test "returns true when macaroon present" do
      conn = %Conn{macaroon_hex: "abc123"}

      assert Conn.authenticated?(conn)
    end
  end

  describe "summary/1" do
    test "returns connection summary" do
      channel = %GRPC.Channel{host: "localhost", port: @port}
      connected_at = DateTime.utc_now()
      node_info = %{alias: "alice", identity_pubkey: "02abc123"}

      conn = %Conn{
        channel: channel,
        macaroon_hex: "abc123",
        timeout: 30_000,
        address: "localhost:10009",
        node_info: node_info,
        connected_at: connected_at
      }

      summary = Conn.summary(conn)

      assert summary.address == "localhost:10009"
      assert summary.authenticated == true
      assert summary.timeout == 30_000
      assert summary.connected_at == connected_at
      assert summary.node_alias == "alice"
      assert summary.node_pubkey == "02abc123"
    end

    test "handles missing node info gracefully" do
      channel = %GRPC.Channel{host: "localhost", port: @port}

      conn = %Conn{
        channel: channel,
        macaroon_hex: nil,
        timeout: 30_000,
        address: "localhost:10009",
        node_info: nil,
        connected_at: DateTime.utc_now()
      }

      summary = Conn.summary(conn)

      assert summary.authenticated == false
      assert summary.node_alias == nil
      assert summary.node_pubkey == nil
    end

    test "handles partial node info" do
      channel = %GRPC.Channel{host: "localhost", port: @port}

      conn = %Conn{
        channel: channel,
        macaroon_hex: "abc123",
        timeout: 30_000,
        address: "localhost:10009",
        # missing identity_pubkey
        node_info: %{alias: "alice"},
        connected_at: DateTime.utc_now()
      }

      summary = Conn.summary(conn)

      assert summary.node_alias == "alice"
      assert summary.node_pubkey == nil
    end
  end
end
