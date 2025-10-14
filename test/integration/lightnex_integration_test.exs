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
  alias Lightnex.LNRPC.Lightning
  alias Lightnex.LNRPC.State

  import Lightnex.LNHelpers
  import Lightnex.TestUtils

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

      assert safe_disconnect(conn) == :ok
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

      assert safe_disconnect(conn) == :ok
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

      assert safe_disconnect(conn) == :ok
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

      assert safe_disconnect(conn) == :ok
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

      assert safe_disconnect(conn) == :ok
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

      assert safe_disconnect(conn) == :ok
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

      assert safe_disconnect(conn) == :ok
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
      assert safe_disconnect_peer(alice_conn, bob_pubkey) == :ok

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
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
      assert safe_disconnect_peer(bob_conn, alice_pubkey) == :ok

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
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
      assert safe_disconnect_peer(alice_conn, bob_info.identity_pubkey) == :ok

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
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

      assert safe_disconnect(alice_conn) == :ok
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
      assert safe_disconnect_peer(alice_conn, bob_pubkey) == :ok
      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
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
      assert safe_disconnect_peer(alice_conn, bob_pubkey) == :ok
      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
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
      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
    end

    test "can disconnect from peer" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect and verify peer is listed
      {:ok, _} = Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")
      assert {:ok, response_before} = Lightnex.list_peers(alice_conn)
      assert length(response_before.peers) >= 1
      assert Enum.any?(response_before.peers, fn peer -> peer.pub_key == bob_pubkey end)

      # Disconnect - this should succeed even if peer reconnects automatically
      assert safe_disconnect_peer(alice_conn, bob_pubkey) == :ok

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
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
      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
    end
  end

  describe "open_channel_sync/4" do
    @describetag timeout: :timer.minutes(5)

    test "opens a basic channel between Alice and Bob" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      # Clean up any existing channels from previous runs
      close_all_channels(alice_conn)
      close_all_channels(bob_conn)

      # Fund Alice's wallet (needed to open channels)
      :ok = fund_wallet(alice_conn, 0.1)

      # Get Bob's info
      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect peers first (required before opening channel)
      {:ok, _} = Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # Open channel (1M sats)
      assert {:ok, %Lightning.ChannelPoint{} = channel_point} =
               Lightnex.open_channel_sync(alice_conn, bob_pubkey, 1_000_000)

      # Verify channel point has required fields
      assert {:funding_txid_bytes, txid_bytes} = channel_point.funding_txid
      assert is_binary(txid_bytes)
      assert is_integer(channel_point.output_index)

      # Mine blocks to confirm the channel (need at least 3 confirmations for channel to be active)
      mine_blocks(6)

      # Wait for channel to be confirmed and appear in active list
      alice_channel = wait_for_active_channel(alice_conn, bob_pubkey)

      assert alice_channel != nil
      assert alice_channel.capacity == 1_000_000
      assert alice_channel.local_balance > 0

      # Clean up: close the channel
      close_channel_and_wait(alice_conn, channel_point)

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
    end

    test "opens channel with push_sat and custom options" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      # Fund Alice's wallet
      :ok = fund_wallet(alice_conn, 0.1)

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect peers
      Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # Open channel with push_sat (push 100k sats to Bob)
      assert {:ok, channel_point} =
               Lightnex.open_channel_sync(alice_conn, bob_pubkey, 2_000_000,
                 push_sat: 100_000,
                 memo: "Test channel with push"
               )

      # Mine blocks to confirm
      mine_blocks(6)

      assert_eventually do
        # Verify channel in Bob's list (he should have the pushed amount)
        {:ok, alice_info} = Lightnex.get_info(alice_conn)
        assert {:ok, bob_channels} = Lightnex.list_channels(bob_conn)

        bob_channel =
          Enum.find(bob_channels.channels, fn ch ->
            ch.remote_pubkey == alice_info.identity_pubkey
          end)

        assert bob_channel != nil
        assert bob_channel.capacity == 2_000_000
        # Bob should have the pushed amount in his remote balance (from his perspective)
        assert bob_channel.remote_balance >= 100_000
      end

      # Clean up
      close_channel_and_wait(alice_conn, channel_point)

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
    end

    test "opens private channel" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      # Fund Alice's wallet
      :ok = fund_wallet(alice_conn, 0.1)

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect peers
      Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # Open private channel
      assert {:ok, channel_point} =
               Lightnex.open_channel_sync(alice_conn, bob_pubkey, 500_000,
                 private: true,
                 memo: "Private test channel"
               )

      # Mine blocks to confirm
      mine_blocks(6)

      assert_eventually do
        # Verify channel is marked as private
        assert {:ok, response} = Lightnex.list_channels(alice_conn, private_only: true)
        private_channel = Enum.find(response.channels, fn ch -> ch.remote_pubkey == bob_pubkey end)

        assert private_channel != nil
        assert private_channel.private == true
      end

      # Clean up
      close_channel_and_wait(alice_conn, channel_point)

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
    end

    test "fails to open channel without peer connection" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Disconnect if connected
      safe_disconnect_peer(alice_conn, bob_pubkey)

      assert_eventually do
        # Try to open channel without connecting peer first
        assert {:error, %GRPC.RPCError{status: 2}} =
                 Lightnex.open_channel_sync(alice_conn, bob_pubkey, 1_000_000)
      end

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
    end

    test "verifies channel appears in pending_channels during confirmation" do
      {:ok, alice_conn} = connect_alice()
      {:ok, bob_conn} = connect_bob()

      # Fund Alice's wallet
      :ok = fund_wallet(alice_conn, 0.1)

      {:ok, bob_info} = Lightnex.get_info(bob_conn)
      bob_pubkey = bob_info.identity_pubkey

      # Connect peers
      {:ok, _} = Lightnex.connect_peer(alice_conn, bob_pubkey, "lnd-bob:9735")

      # Open channel
      assert {:ok, channel_point} =
               Lightnex.open_channel_sync(alice_conn, bob_pubkey, 750_000)

      # Check pending channels before mining blocks
      assert {:ok, pending} = Lightnex.pending_channels(alice_conn)

      # Channel should be in pending_open_channels
      assert length(pending.pending_open_channels) >= 1

      pending_channel =
        Enum.find(pending.pending_open_channels, fn ch ->
          ch.channel.remote_node_pub == bob_pubkey
        end)

      assert pending_channel != nil
      assert pending_channel.channel.capacity == 750_000

      # Mine blocks to confirm
      mine_blocks(6)

      # After confirmation, should move to active channels
      assert_eventually do
        assert {:ok, channels} = Lightnex.list_channels(alice_conn, active_only: true)
        assert length(channels.channels) >= 1
      end

      # Clean up
      close_channel_and_wait(alice_conn, channel_point)

      assert safe_disconnect(alice_conn) == :ok
      assert safe_disconnect(bob_conn) == :ok
    end
  end

  ## Private functions

  # Helper to get a Bitcoin RPC client
  defp btc_client do
    BTx.RPC.client(
      base_url: "http://localhost:18443/",
      username: "bitcoin",
      password: "bitcoin",
      retry_opts: [max_retries: 10, delay: :timer.seconds(1)]
    )
  end

  # Helper to wait for a channel to become active
  defp wait_for_active_channel(conn, remote_pubkey, retries \\ 120) do
    case Lightnex.list_channels(conn, active_only: true) do
      {:ok, %{channels: channels}} ->
        check_channel_active(conn, channels, remote_pubkey, retries)

      {:error, _reason} when retries > 0 ->
        Process.sleep(250)
        wait_for_active_channel(conn, remote_pubkey, retries - 1)

      _ ->
        nil
    end
  end

  defp check_channel_active(conn, channels, remote_pubkey, retries) do
    channel = Enum.find(channels, &(&1.remote_pubkey == remote_pubkey))

    cond do
      not is_nil(channel) ->
        IO.puts("✓ Channel active")
        channel

      retries > 0 ->
        if rem(retries, 5) == 0 do
          IO.puts("  Waiting for channel to become active... (#{retries}s remaining)")
        end

        Process.sleep(250)
        wait_for_active_channel(conn, remote_pubkey, retries - 1)

      true ->
        nil
    end
  end

  # Helper to close all existing channels for a node
  defp close_all_channels(conn) do
    # Close all active channels
    case Lightnex.list_channels(conn) do
      {:ok, %{channels: [_ | _] = channels}} ->
        Enum.each(channels, fn channel ->
          channel_point = parse_channel_point(channel.channel_point)
          Lightnex.close_channel(conn, channel_point, force: true)
        end)

      _ ->
        :ok
    end

    # Close all pending channels
    case Lightnex.pending_channels(conn) do
      {:ok, pending} ->
        # Force close pending open channels
        Enum.each(pending.pending_open_channels, fn pending_chan ->
          channel_point = parse_channel_point(pending_chan.channel.channel_point)
          Lightnex.close_channel(conn, channel_point, force: true)
        end)

      # Note: pending_closing_channels are already closing, no action needed

      _ ->
        :ok
    end

    # Mine blocks to confirm force closes
    mine_blocks(150)
    Process.sleep(3000)

    :ok
  end

  # Helper to parse channel_point string into ChannelPoint struct
  defp parse_channel_point(channel_point_str) do
    [txid_str, output_index_str] = String.split(channel_point_str, ":")

    txid_bytes =
      Base.decode16!(txid_str, case: :mixed)
      |> :binary.decode_unsigned(:big)
      |> :binary.encode_unsigned(:little)

    output_index = String.to_integer(output_index_str)

    %Lightning.ChannelPoint{
      funding_txid: {:funding_txid_bytes, txid_bytes},
      output_index: output_index
    }
  end

  # Helper to fund a node's wallet with Bitcoin
  defp fund_wallet(conn, amount_btc) do
    client = btc_client()
    wallet = "miner"

    # Get a new address from the LND node (use nested SegWit for compatibility)
    {:ok, response} = Lightnex.new_address(conn, type: :NESTED_PUBKEY_HASH)
    lnd_address = response.address

    IO.puts("Generated LND address: #{lnd_address}")

    # Load miner wallet
    BTx.RPC.Wallets.load_wallet(client, filename: wallet)

    # Send funds from miner wallet to LND address
    BTx.RPC.Wallets.send_to_address!(client,
      address: lnd_address,
      amount: amount_btc,
      wallet_name: wallet
    )

    IO.puts("Sent #{amount_btc} BTC to LND address")

    # Mine blocks to confirm the transaction
    mine_blocks(6)

    # Give LND time to process the blocks
    Process.sleep(3000)

    # Wait for LND to see the confirmed balance
    wait_for_balance(conn, amount_btc)

    :ok
  end

  # Helper to wait for wallet balance to be confirmed
  defp wait_for_balance(conn, expected_btc, retries \\ 120) do
    expected_sats = trunc(expected_btc * 100_000_000)

    case Lightnex.wallet_balance(conn) do
      {:ok, balance} when balance.confirmed_balance >= expected_sats ->
        IO.puts("✓ Wallet funded: #{balance.confirmed_balance} sats")
        :ok

      {:ok, balance} when retries > 0 ->
        if rem(retries, 5) == 0 do
          IO.puts(
            "  Waiting for balance... (#{balance.confirmed_balance}/#{expected_sats} sats, #{retries}s remaining)"
          )
        end

        Process.sleep(250)
        wait_for_balance(conn, expected_btc, retries - 1)

      {:ok, balance} ->
        raise "Wallet balance not confirmed after 30 seconds. Got #{balance.confirmed_balance} sats, expected #{expected_sats}"

      {:error, reason} ->
        raise "Failed to check wallet balance: #{inspect(reason)}"
    end
  end

  # Helper to mine blocks on the regtest network
  defp mine_blocks(num_blocks) do
    client = btc_client()
    wallet = "miner"

    # Load wallet if not already loaded
    BTx.RPC.Wallets.load_wallet(client, filename: wallet)

    # Get an address from the miner wallet
    address = BTx.RPC.Wallets.get_new_address!(client, wallet_name: wallet)

    # Mine blocks to that address
    BTx.RPC.Mining.generate_to_address!(client, nblocks: num_blocks, address: address)

    :ok
  end

  # Helper to close a channel and wait for closure
  defp close_channel_and_wait(conn, channel_point) do
    # Initiate cooperative close
    {:ok, stream} = Lightnex.close_channel(conn, channel_point)

    # Spawn a task to consume the stream in the background (don't block on it)
    Task.start(fn ->
      try do
        Enum.each(stream, fn _update -> :ok end)
      rescue
        _ -> :ok
      end
    end)

    # Give the close some time to be broadcast
    Process.sleep(2000)

    # Mine blocks to confirm the closing transaction
    mine_blocks(10)

    # Wait for channel to be fully closed
    Process.sleep(5000)

    :ok
  end

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
