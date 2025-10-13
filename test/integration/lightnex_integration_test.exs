defmodule LightnexIntegrationTest do
  @moduledoc """
  Integration tests for Lightnex with real LND nodes.

  These tests automatically handle wallet creation and unlocking.
  No manual intervention required - perfect for CI/CD!

  Run with: `mix test --only integration`
  """
  use ExUnit.Case, async: false
  @moduletag :integration

  alias Lightnex.Conn
  alias Lightnex.LNRPC.State

  import Lightnex.LNHelpers

  setup_all do
    IO.puts("\n🚀 Setting up LND nodes for integration tests...")

    # Automatically create and unlock wallets
    {:ok, _} = ensure_wallet_ready(alice_address(), alice_tls_cert(), "Alice")
    {:ok, _} = ensure_wallet_ready(bob_address(), bob_tls_cert(), "Bob")

    # Wait for nodes to reach SERVER_ACTIVE state (not just RPC_ACTIVE)
    IO.puts("⏳ Waiting for nodes to reach SERVER_ACTIVE state...")
    :ok = wait_for_server_active(alice_address(), alice_tls_cert(), alice_macaroon(), "Alice")
    :ok = wait_for_server_active(bob_address(), bob_tls_cert(), bob_macaroon(), "Bob")

    IO.puts("✅ All nodes ready!\n")
    :ok
  end

  describe "connect/2" do
    test "connection validation works with macaroon" do
      assert {:ok, %Conn{} = conn} =
               Lightnex.connect(alice_address(),
                 cred:
                   GRPC.Credential.new(
                     ssl: [
                       cacertfile: alice_tls_cert(),
                       verify: :verify_none
                     ]
                   ),
                 validate: true,
                 macaroon: alice_macaroon(),
                 macaroon_type: :file
               )

      assert is_map(conn.node_info)
      assert conn.node_info.alias == "alice"
      assert Conn.authenticated?(conn)

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "connect to Alice node without authentication" do
      assert {:ok, %Conn{} = conn} =
               Lightnex.connect(alice_address(),
                 cred:
                   GRPC.Credential.new(
                     ssl: [
                       cacertfile: alice_tls_cert(),
                       verify: :verify_none
                     ]
                   ),
                 validate: false
               )

      assert conn.address == alice_address()
      refute Conn.authenticated?(conn)

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "connect to Bob node with authentication" do
      assert {:ok, %Conn{} = conn} =
               Lightnex.connect(bob_address(),
                 cred:
                   GRPC.Credential.new(
                     ssl: [
                       cacertfile: bob_tls_cert(),
                       verify: :verify_none
                     ]
                   ),
                 macaroon: bob_macaroon(),
                 macaroon_type: :file
               )

      assert conn.address == bob_address()
      assert conn.node_info.alias == "bob"
      assert Conn.authenticated?(conn)

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "get_info from Alice" do
      {:ok, conn} =
        Lightnex.connect(alice_address(),
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: alice_tls_cert(),
                verify: :verify_none
              ]
            ),
          macaroon: alice_macaroon(),
          macaroon_type: :file,
          validate: false
        )

      assert {:ok, info} = Lightnex.get_info(conn)
      assert is_binary(info.identity_pubkey)
      assert info.alias == "alice"
      assert is_integer(info.block_height)
      assert info.block_height >= 0
      assert is_boolean(info.synced_to_chain)

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "get_info from Bob" do
      {:ok, conn} =
        Lightnex.connect(bob_address(),
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: bob_tls_cert(),
                verify: :verify_none
              ]
            ),
          macaroon: bob_macaroon(),
          macaroon_type: :file,
          validate: false
        )

      assert {:ok, info} = Lightnex.get_info(conn)
      assert is_binary(info.identity_pubkey)
      assert info.alias == "bob"

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "connection without macaroon fails get_info" do
      {:ok, conn} =
        Lightnex.connect(alice_address(),
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: alice_tls_cert(),
                verify: :verify_none
              ]
            ),
          validate: false
        )

      # Should fail because no macaroon provided
      assert {:error, %GRPC.RPCError{status: 2, message: msg}} = Lightnex.get_info(conn)
      assert msg =~ "expected 1 macaroon"

      {:ok, _} = Lightnex.disconnect(conn)
    end

    @tag :capture_log
    test "connection to invalid address fails" do
      assert {:error, _reason} = Lightnex.connect("localhost:99999")
    end

    test "connection summary includes expected fields" do
      {:ok, conn} =
        Lightnex.connect(alice_address(),
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: alice_tls_cert(),
                verify: :verify_none
              ]
            ),
          macaroon: alice_macaroon(),
          macaroon_type: :file
        )

      summary = Conn.summary(conn)
      assert summary.address == alice_address()
      assert summary.authenticated == true
      assert is_integer(summary.timeout)
      assert %DateTime{} = summary.connected_at
      assert summary.node_alias == "alice"
      assert is_binary(summary.node_pubkey)

      {:ok, _} = Lightnex.disconnect(conn)
    end
  end

  describe "connect_peer/4" do
    test "Alice can connect to Bob" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      # Get Bob's info
      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey
      bob_host = "lnd-bob:9735"

      # Connect - should work immediately since we waited for SERVER_ACTIVE
      assert {:ok, response} = Lightnex.connect_peer(alice_conn, bob_pubkey, bob_host)
      assert is_binary(response.status)

      # Disconnect from Bob
      assert {:ok, _} = Lightnex.disconnect_peer(alice_conn, bob_pubkey)

      assert {:ok, _} = Lightnex.disconnect(alice_conn)
      assert {:ok, _} = Lightnex.disconnect(bob_conn)
    end

    test "Bob can connect to Alice" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, alice_info} = Lightnex.get_info(alice_conn)
      alice_pubkey = alice_info.identity_pubkey
      alice_host = "lnd-alice:9735"

      assert {:ok, response} = Lightnex.connect_peer(bob_conn, alice_pubkey, alice_host)
      assert is_binary(response.status)

      # Disconnect from Alice
      assert {:ok, _} = Lightnex.disconnect_peer(bob_conn, alice_pubkey)

      assert {:ok, _} = Lightnex.disconnect(alice_conn)
      assert {:ok, _} = Lightnex.disconnect(bob_conn)
    end

    test "connecting with perm and timeout options" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, bob_info} = Lightnex.get_info(bob_conn)

      assert {:ok, response} =
               Lightnex.connect_peer(alice_conn, bob_info.identity_pubkey, "lnd-bob:9735",
                 perm: true,
                 timeout: 30
               )

      assert is_binary(response.status)

      # Disconnect from Bob
      assert {:ok, _} = Lightnex.disconnect_peer(alice_conn, bob_info.identity_pubkey)

      assert {:ok, _} = Lightnex.disconnect(alice_conn)
      assert {:ok, _} = Lightnex.disconnect(bob_conn)
    end
  end

  describe "list_peers/2" do
    test "lists peers (may be empty or contain previously connected peers)" do
      {:ok, alice_conn} = connect_alice()

      # List peers - may or may not be empty depending on previous test state
      assert {:ok, response} = Lightnex.list_peers(alice_conn)
      assert is_list(response.peers)
      # Each peer should have the expected structure
      Enum.each(response.peers, fn peer ->
        assert is_binary(peer.pub_key)
        assert is_binary(peer.address)
      end)

      {:ok, _} = Lightnex.disconnect(alice_conn)
    end

    test "lists connected peer after connection established" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      # Get Bob's info
      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect Alice to Bob
      assert {:ok, _} = Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # List peers from Alice's perspective
      assert {:ok, response} = Lightnex.list_peers(alice_conn)
      assert is_list(response.peers)
      assert length(response.peers) == 1

      [peer] = response.peers
      assert peer.pub_key == bob_pubkey
      assert is_binary(peer.address)
      assert String.contains?(peer.address, "9735")
      assert is_integer(peer.bytes_sent)
      assert is_integer(peer.bytes_recv)
      assert is_integer(peer.sat_sent)
      assert is_integer(peer.sat_recv)
      assert is_boolean(peer.inbound)

      # Clean up
      assert {:ok, _} = Lightnex.disconnect_peer(alice_conn, bob_pubkey)
      {:ok, _} = Lightnex.disconnect(alice_conn)
      {:ok, _} = Lightnex.disconnect(bob_conn)
    end

    test "lists peers from both nodes' perspectives" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, alice_info} = Lightnex.get_info(alice_conn)
      {:ok, bob_info} = Lightnex.get_info(bob_conn)

      alice_pubkey = alice_info.identity_pubkey
      bob_pubkey = bob_info.identity_pubkey

      # Connect Alice to Bob
      assert {:ok, _} = Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # Both nodes should see the peer connection
      assert {:ok, alice_response} = Lightnex.list_peers(alice_conn)
      assert length(alice_response.peers) == 1
      assert hd(alice_response.peers).pub_key == bob_pubkey

      assert {:ok, bob_response} = Lightnex.list_peers(bob_conn)
      assert length(bob_response.peers) == 1
      assert hd(bob_response.peers).pub_key == alice_pubkey

      # Clean up
      assert {:ok, _} = Lightnex.disconnect_peer(alice_conn, bob_pubkey)
      {:ok, _} = Lightnex.disconnect(alice_conn)
      {:ok, _} = Lightnex.disconnect(bob_conn)
    end

    test "lists peers with latest_error option" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect Alice to Bob (may already be connected)
      Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # List peers with latest_error option enabled
      assert {:ok, response} = Lightnex.list_peers(alice_conn, latest_error: true)
      assert is_list(response.peers)
      assert length(response.peers) >= 1

      # Find Bob in the peer list
      bob_peer = Enum.find(response.peers, fn peer -> peer.pub_key == bob_pubkey end)
      assert bob_peer != nil
      # Flap timestamps should be present
      assert is_integer(bob_peer.last_flap_ns)

      # Clean up
      Lightnex.disconnect_peer(alice_conn, bob_pubkey)
      {:ok, _} = Lightnex.disconnect(alice_conn)
      {:ok, _} = Lightnex.disconnect(bob_conn)
    end

    test "can disconnect from peer" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect and verify peer is listed
      Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")
      assert {:ok, response_before} = Lightnex.list_peers(alice_conn)
      assert length(response_before.peers) >= 1
      assert Enum.any?(response_before.peers, fn peer -> peer.pub_key == bob_pubkey end)

      # Disconnect - this should succeed even if peer reconnects automatically
      assert {:ok, _} = Lightnex.disconnect_peer(alice_conn, bob_pubkey)

      {:ok, _} = Lightnex.disconnect(alice_conn)
      {:ok, _} = Lightnex.disconnect(bob_conn)
    end

    test "verifies peer connection details" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect Alice to Bob (may already be connected)
      Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # Get detailed peer information
      assert {:ok, response} = Lightnex.list_peers(alice_conn)
      assert length(response.peers) >= 1

      # Find Bob in the peer list
      bob_peer = Enum.find(response.peers, fn peer -> peer.pub_key == bob_pubkey end)
      assert bob_peer != nil

      # Verify peer structure and fields
      assert bob_peer.pub_key == bob_pubkey
      assert is_binary(bob_peer.address)
      assert bob_peer.bytes_sent >= 0
      assert bob_peer.bytes_recv >= 0
      assert bob_peer.sat_sent >= 0
      assert bob_peer.sat_recv >= 0
      assert is_boolean(bob_peer.inbound)
      assert is_integer(bob_peer.ping_time)
      assert is_map(bob_peer.features)
      assert is_list(bob_peer.errors)

      # Clean up
      Lightnex.disconnect_peer(alice_conn, bob_pubkey)
      {:ok, _} = Lightnex.disconnect(alice_conn)
      {:ok, _} = Lightnex.disconnect(bob_conn)
    end
  end

  ## Private functions

  # Helper function to wait for SERVER_ACTIVE state (state 4)
  defp wait_for_server_active(address, tls_cert, macaroon, node_name, retries \\ 60) do
    {:ok, conn} =
      Lightnex.connect(address,
        cred: GRPC.Credential.new(ssl: [cacertfile: tls_cert, verify: :verify_none]),
        macaroon: macaroon,
        macaroon_type: :file,
        validate: false
      )

    request = %State.GetStateRequest{}
    metadata = Conn.grpc_metadata(conn)

    case State.Stub.get_state(conn.channel, request, metadata: metadata) do
      {:ok, %{state: :SERVER_ACTIVE}} ->
        # SERVER_ACTIVE = 4
        IO.puts("  ✅ #{node_name} reached SERVER_ACTIVE")
        Lightnex.disconnect(conn)
        :ok

      {:ok, %{state: state}} when retries > 0 ->
        IO.write("  ⏳ #{node_name} state: #{state}, waiting... (#{60 - retries + 1}/60)\r")

        Lightnex.disconnect(conn)
        Process.sleep(1000)
        wait_for_server_active(address, tls_cert, macaroon, node_name, retries - 1)

      {:error, reason} when retries > 0 ->
        IO.write("  ⚠️  #{node_name} error (retrying): #{inspect(reason)}\r")
        Lightnex.disconnect(conn)
        Process.sleep(1000)
        wait_for_server_active(address, tls_cert, macaroon, node_name, retries - 1)

      other ->
        IO.puts("\n  ❌ #{node_name} failed to reach SERVER_ACTIVE: #{inspect(other)}")
        Lightnex.disconnect(conn)
        {:error, :timeout}
    end
  end
end
