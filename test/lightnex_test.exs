defmodule LightnexTest do
  use ExUnit.Case, async: false
  use Mimic

  @moduletag capture_log: true

  import Lightnex.LightningFixtures

  alias Lightnex.Conn
  alias Lightnex.Conn.NodeInfo
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

    test "connection with validation calls get_info" do
      mock_channel = grpc_channel()
      get_info_response = get_info_response(alias: "test-node")

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      Lightning.Stub
      |> expect(:get_info, fn ^mock_channel, %Lightning.GetInfoRequest{}, metadata: %{} ->
        {:ok, get_info_response}
      end)

      assert {:ok, %Conn{} = conn} = Lightnex.connect(@address, validate: true)

      assert %NodeInfo{} = conn.node_info
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

    test "connection fails when validation fails" do
      mock_channel = grpc_channel()

      GRPC.Stub
      |> expect(:connect, fn @address, [] ->
        {:ok, mock_channel}
      end)

      Lightning.Stub
      |> expect(:get_info, fn ^mock_channel, %Lightning.GetInfoRequest{}, metadata: %{} ->
        grpc_error(:permission_denied)
      end)

      assert {:error, %GRPC.RPCError{status: 7, message: "permission denied"}} =
               Lightnex.connect(@address, validate: true)
    end
  end

  describe "get_info/1" do
    setup :verify_on_exit!

    test "successful get_info call returns NodeInfo struct" do
      conn = authenticated_connection()
      get_info_response = get_info_response()
      macaroon = conn.macaroon_hex

      Lightning.Stub
      |> expect(:get_info, fn %GRPC.Channel{},
                              %Lightning.GetInfoRequest{},
                              metadata: %{macaroon: ^macaroon} ->
        {:ok, get_info_response}
      end)

      assert {:ok, %NodeInfo{} = info} = Lightnex.get_info(conn)

      assert info.identity_pubkey == get_info_response.identity_pubkey
      assert info.alias == get_info_response.alias
      assert info.num_active_channels == get_info_response.num_active_channels
      assert info.synced_to_chain == get_info_response.synced_to_chain
    end

    test "get_info fails with error" do
      conn = connection()

      Lightning.Stub
      |> expect(:get_info, fn _conn, %Lightning.GetInfoRequest{}, metadata: %{} ->
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

  describe "connect_peer/4" do
    setup :verify_on_exit!

    test "successfully connects to peer" do
      conn = authenticated_connection()
      pubkey = "02abc123"
      host = "192.168.1.100:9735"

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, request, metadata: _ ->
        assert request.addr.pubkey == "02abc123"
        assert request.addr.host == host
        assert request.perm == false
        {:ok, %Lightning.ConnectPeerResponse{}}
      end)

      assert {:ok, %Lightning.ConnectPeerResponse{}} =
               Lightnex.connect_peer(conn, pubkey, host)
    end

    test "connects with permanent connection option" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, request, metadata: _ ->
        assert request.perm == true
        {:ok, %Lightning.ConnectPeerResponse{}}
      end)

      assert {:ok, _} = Lightnex.connect_peer(conn, "02abc123", "host:9735", perm: true)
    end

    test "handles already connected error gracefully" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, _request, metadata: _ ->
        {:error, %GRPC.RPCError{status: 2, message: "already connected to peer"}}
      end)

      # Should return success even though peer is already connected
      assert {:ok, %Lightning.ConnectPeerResponse{}} =
               Lightnex.connect_peer(conn, "02abc123", "host:9735")
    end

    test "fails with other errors" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} =
               Lightnex.connect_peer(conn, "02abc123", "host:9735")
    end

    test "handles generic errors that are not 'already connected'" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, _request, metadata: _ ->
        # A different error that's NOT "already connected"
        {:error, %GRPC.RPCError{status: 5, message: "peer not found"}}
      end)

      # Should propagate the error (covers line 273-274)
      assert {:error, %GRPC.RPCError{status: 5, message: "peer not found"}} =
               Lightnex.connect_peer(conn, "02abc123", "host:9735")
    end

    test "logs and returns other errors" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, _request, metadata: _ ->
        # Return an error that's NOT "already connected"
        {:error, :other_error}
      end)

      # Should log the error and propagate it (covers line 273-274)
      assert Lightnex.connect_peer(conn, "02abc123", "host:9735") == {:error, :other_error}
    end
  end

  describe "disconnect_peer/2" do
    setup :verify_on_exit!

    test "successfully disconnects from peer" do
      conn = authenticated_connection()
      pubkey = "02abc123"

      Lightning.Stub
      |> expect(:disconnect_peer, fn _channel, request, metadata: _ ->
        assert request.pub_key == "02abc123"
        {:ok, %Lightning.DisconnectPeerResponse{}}
      end)

      assert {:ok, %Lightning.DisconnectPeerResponse{}} =
               Lightnex.disconnect_peer(conn, pubkey)
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:disconnect_peer, fn _channel, _request, metadata: _ ->
        grpc_error(:not_found)
      end)

      assert {:error, %GRPC.RPCError{status: 5}} =
               Lightnex.disconnect_peer(conn, "02abc123")
    end
  end

  describe "list_peers/2" do
    setup :verify_on_exit!

    test "successfully lists peers" do
      conn = authenticated_connection()
      peers_response = list_peers_response()

      Lightning.Stub
      |> expect(:list_peers, fn _channel, request, metadata: _ ->
        assert request.latest_error == false
        {:ok, peers_response}
      end)

      assert {:ok, response} = Lightnex.list_peers(conn)
      assert length(response.peers) == 2
    end

    test "lists peers with latest_error option" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:list_peers, fn _channel, request, metadata: _ ->
        assert request.latest_error == true
        {:ok, list_peers_response()}
      end)

      assert {:ok, _} = Lightnex.list_peers(conn, latest_error: true)
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:list_peers, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} = Lightnex.list_peers(conn)
    end
  end

  describe "open_channel_sync/4" do
    setup :verify_on_exit!

    test "successfully opens channel" do
      conn = authenticated_connection()
      pubkey = "02abc123"
      amount = 1_000_000

      # ChannelPoint with oneof field must use tuple syntax
      channel_point = %Lightning.ChannelPoint{
        funding_txid: {:funding_txid_bytes, <<1, 2, 3, 4>>},
        output_index: 0
      }

      Lightning.Stub
      |> expect(:open_channel_sync, fn _channel, request, metadata: _ ->
        assert request.node_pubkey == "02abc123"
        assert request.local_funding_amount == amount
        assert request.push_sat == 0
        assert request.private == false
        {:ok, channel_point}
      end)

      assert Lightnex.open_channel_sync(conn, pubkey, amount) == {:ok, channel_point}
    end

    test "opens channel with custom options" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:open_channel_sync, fn _channel, request, metadata: _ ->
        assert request.push_sat == 100_000
        assert request.private == true
        assert request.target_conf == 3
        assert request.memo == "test channel"
        {:ok, %Lightning.ChannelPoint{}}
      end)

      opts = [
        push_sat: 100_000,
        private: true,
        target_conf: 3,
        memo: "test channel"
      ]

      assert {:ok, _} = Lightnex.open_channel_sync(conn, "02abc123", 1_000_000, opts)
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:open_channel_sync, fn _channel, _request, metadata: _ ->
        grpc_error(:invalid_argument)
      end)

      assert {:error, %GRPC.RPCError{status: 3}} =
               Lightnex.open_channel_sync(conn, "02abc123", 1_000_000)
    end
  end

  describe "list_channels/2" do
    setup :verify_on_exit!

    test "successfully lists all channels" do
      conn = authenticated_connection()
      channels_response = list_channels_response()

      Lightning.Stub
      |> expect(:list_channels, fn _channel, request, metadata: _ ->
        assert request.active_only == false
        assert request.inactive_only == false
        {:ok, channels_response}
      end)

      assert {:ok, response} = Lightnex.list_channels(conn)
      assert length(response.channels) == 2
    end

    test "lists only active channels" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:list_channels, fn _channel, request, metadata: _ ->
        assert request.active_only == true
        {:ok, list_channels_response()}
      end)

      assert {:ok, _} = Lightnex.list_channels(conn, active_only: true)
    end

    test "lists only private channels" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:list_channels, fn _channel, request, metadata: _ ->
        assert request.private_only == true
        {:ok, list_channels_response()}
      end)

      assert {:ok, _} = Lightnex.list_channels(conn, private_only: true)
    end

    test "filters by peer" do
      conn = authenticated_connection()
      peer_pubkey = <<2, 171, 193, 35>>

      Lightning.Stub
      |> expect(:list_channels, fn _channel, request, metadata: _ ->
        assert request.peer == peer_pubkey
        {:ok, list_channels_response()}
      end)

      assert {:ok, _} = Lightnex.list_channels(conn, peer: peer_pubkey)
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:list_channels, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} = Lightnex.list_channels(conn)
    end
  end

  describe "pending_channels/1" do
    setup :verify_on_exit!

    test "successfully gets pending channels" do
      conn = authenticated_connection()

      response = %Lightning.PendingChannelsResponse{
        pending_open_channels: [],
        pending_closing_channels: [],
        pending_force_closing_channels: [],
        waiting_close_channels: []
      }

      Lightning.Stub
      |> expect(:pending_channels, fn _channel, _request, metadata: _ ->
        {:ok, response}
      end)

      assert {:ok, ^response} = Lightnex.pending_channels(conn)
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:pending_channels, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} = Lightnex.pending_channels(conn)
    end
  end

  describe "closed_channels/2" do
    setup :verify_on_exit!

    test "successfully gets all closed channels" do
      conn = authenticated_connection()

      response = %Lightning.ClosedChannelsResponse{channels: []}

      Lightning.Stub
      |> expect(:closed_channels, fn _channel, request, metadata: _ ->
        assert request.cooperative == false
        assert request.local_force == false
        {:ok, response}
      end)

      assert {:ok, ^response} = Lightnex.closed_channels(conn)
    end

    test "filters by cooperative closes" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:closed_channels, fn _channel, request, metadata: _ ->
        assert request.cooperative == true
        {:ok, %Lightning.ClosedChannelsResponse{channels: []}}
      end)

      assert {:ok, _} = Lightnex.closed_channels(conn, cooperative: true)
    end

    test "filters by force closes" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:closed_channels, fn _channel, request, metadata: _ ->
        assert request.local_force == true
        assert request.remote_force == true
        {:ok, %Lightning.ClosedChannelsResponse{channels: []}}
      end)

      opts = [local_force: true, remote_force: true]
      assert {:ok, _} = Lightnex.closed_channels(conn, opts)
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:closed_channels, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} = Lightnex.closed_channels(conn)
    end
  end

  describe "new_address/2" do
    setup :verify_on_exit!

    test "successfully generates new address" do
      conn = authenticated_connection()
      response = new_address_response()

      Lightning.Stub
      |> expect(:new_address, fn _channel, request, metadata: _ ->
        assert request.type == :WITNESS_PUBKEY_HASH
        assert request.account == "default"
        {:ok, response}
      end)

      assert {:ok, ^response} = Lightnex.new_address(conn)
      assert response.address == "bcrt1qw508d6qejxtdg4y5r3zarvary0c5xw7kygt080"
    end

    test "generates taproot address" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:new_address, fn _channel, request, metadata: _ ->
        assert request.type == :TAPROOT_PUBKEY
        {:ok, new_address_response()}
      end)

      assert {:ok, _} = Lightnex.new_address(conn, type: :TAPROOT_PUBKEY)
    end

    test "uses custom account" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:new_address, fn _channel, request, metadata: _ ->
        assert request.account == "savings"
        {:ok, new_address_response()}
      end)

      assert {:ok, _} = Lightnex.new_address(conn, account: "savings")
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:new_address, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} = Lightnex.new_address(conn)
    end
  end

  describe "wallet_balance/1" do
    setup :verify_on_exit!

    test "successfully gets wallet balance" do
      conn = authenticated_connection()

      response = %Lightning.WalletBalanceResponse{
        total_balance: 1_000_000,
        confirmed_balance: 900_000,
        unconfirmed_balance: 100_000
      }

      Lightning.Stub
      |> expect(:wallet_balance, fn _channel, _request, metadata: _ ->
        {:ok, response}
      end)

      assert {:ok, ^response} = Lightnex.wallet_balance(conn)
      assert response.total_balance == 1_000_000
      assert response.confirmed_balance == 900_000
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:wallet_balance, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} = Lightnex.wallet_balance(conn)
    end
  end

  describe "channel_balance/1" do
    setup :verify_on_exit!

    test "successfully gets channel balance" do
      conn = authenticated_connection()

      response = %Lightning.ChannelBalanceResponse{
        balance: 500_000,
        pending_open_balance: 100_000
      }

      Lightning.Stub
      |> expect(:channel_balance, fn _channel, _request, metadata: _ ->
        {:ok, response}
      end)

      assert {:ok, ^response} = Lightnex.channel_balance(conn)
      assert response.balance == 500_000
      assert response.pending_open_balance == 100_000
    end

    test "fails with error" do
      conn = authenticated_connection()

      Lightning.Stub
      |> expect(:channel_balance, fn _channel, _request, metadata: _ ->
        grpc_error(:unavailable)
      end)

      assert {:error, %GRPC.RPCError{status: 14}} = Lightnex.channel_balance(conn)
    end
  end

  describe "normalize_pubkey/1 edge cases" do
    setup :verify_on_exit!

    test "converts 66-char valid hex pubkey to binary" do
      conn = authenticated_connection()
      # Valid 66-char hex string (33 bytes)
      pubkey_hex = String.duplicate("02", 33)
      expected_binary = Base.decode16!(pubkey_hex, case: :mixed)

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, request, metadata: _ ->
        # Should be converted to binary (covers line 771)
        assert request.addr.pubkey == expected_binary
        {:ok, %Lightning.ConnectPeerResponse{}}
      end)

      assert {:ok, _} = Lightnex.connect_peer(conn, pubkey_hex, "host:9735")
    end

    test "passes through non-hex binary unchanged" do
      conn = authenticated_connection()
      # Binary that's not valid hex
      pubkey_binary = <<2, 171, 193, 35>>

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, request, metadata: _ ->
        # Should pass through unchanged (covers line 772)
        assert request.addr.pubkey == pubkey_binary
        {:ok, %Lightning.ConnectPeerResponse{}}
      end)

      assert {:ok, _} = Lightnex.connect_peer(conn, pubkey_binary, "host:9735")
    end

    test "passes through invalid hex string unchanged" do
      conn = authenticated_connection()
      # Invalid hex characters
      # 66 chars but invalid
      invalid_hex = String.duplicate("0", 64) <> "XY"

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, request, metadata: _ ->
        # Should pass through unchanged (covers line 772 - decode error)
        assert request.addr.pubkey == invalid_hex
        {:ok, %Lightning.ConnectPeerResponse{}}
      end)

      assert {:ok, _} = Lightnex.connect_peer(conn, invalid_hex, "host:9735")
    end

    test "passes through short hex string unchanged" do
      conn = authenticated_connection()
      # Only 10 chars, not 66
      short_hex = "02abc12345"

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, request, metadata: _ ->
        # Should pass through unchanged (length check fails)
        assert request.addr.pubkey == short_hex
        {:ok, %Lightning.ConnectPeerResponse{}}
      end)

      assert {:ok, _} = Lightnex.connect_peer(conn, short_hex, "host:9735")
    end

    test "handles uppercase hex correctly" do
      conn = authenticated_connection()
      # Uppercase hex, 66 chars
      pubkey_hex_upper = String.duplicate("02", 33) |> String.upcase()
      expected_binary = Base.decode16!(pubkey_hex_upper, case: :mixed)

      Lightning.Stub
      |> expect(:connect_peer, fn _channel, request, metadata: _ ->
        # Should be converted to binary (covers line 771 with uppercase)
        assert request.addr.pubkey == expected_binary
        {:ok, %Lightning.ConnectPeerResponse{}}
      end)

      assert {:ok, _} = Lightnex.connect_peer(conn, pubkey_hex_upper, "host:9735")
    end
  end
end
