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

  import Lightnex.WalletHelper

  @alice_address "localhost:10009"
  @bob_address "localhost:10010"

  @alice_tls_cert "docker/data/lnd-alice/tls.cert"
  @bob_tls_cert "docker/data/lnd-bob/tls.cert"

  @alice_macaroon "docker/data/lnd-alice/data/chain/bitcoin/regtest/admin.macaroon"
  @bob_macaroon "docker/data/lnd-bob/data/chain/bitcoin/regtest/admin.macaroon"

  setup_all do
    IO.puts("\n🚀 Setting up LND nodes for integration tests...")

    # Automatically create and unlock wallets
    {:ok, _} = ensure_wallet_ready(@alice_address, @alice_tls_cert, "Alice")
    {:ok, _} = ensure_wallet_ready(@bob_address, @bob_tls_cert, "Bob")

    IO.puts("✅ All nodes ready!\n")
    :ok
  end

  describe "connect/2" do
    test "connection validation works with macaroon" do
      assert {:ok, %Conn{} = conn} =
               Lightnex.connect(@alice_address,
                 cred:
                   GRPC.Credential.new(
                     ssl: [
                       cacertfile: @alice_tls_cert,
                       verify: :verify_none
                     ]
                   ),
                 validate: true,
                 macaroon: @alice_macaroon,
                 macaroon_type: :file
               )

      assert is_map(conn.node_info)
      assert conn.node_info.alias == "alice"
      assert Conn.authenticated?(conn)

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "connect to Alice node without authentication" do
      assert {:ok, %Conn{} = conn} =
               Lightnex.connect(@alice_address,
                 cred:
                   GRPC.Credential.new(
                     ssl: [
                       cacertfile: @alice_tls_cert,
                       verify: :verify_none
                     ]
                   ),
                 validate: false
               )

      assert conn.address == @alice_address
      refute Conn.authenticated?(conn)

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "connect to Bob node with authentication" do
      assert {:ok, %Conn{} = conn} =
               Lightnex.connect(@bob_address,
                 cred:
                   GRPC.Credential.new(
                     ssl: [
                       cacertfile: @bob_tls_cert,
                       verify: :verify_none
                     ]
                   ),
                 macaroon: @bob_macaroon,
                 macaroon_type: :file
               )

      assert conn.address == @bob_address
      assert conn.node_info.alias == "bob"
      assert Conn.authenticated?(conn)

      {:ok, _} = Lightnex.disconnect(conn)
    end

    test "get_info from Alice" do
      {:ok, conn} =
        Lightnex.connect(@alice_address,
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: @alice_tls_cert,
                verify: :verify_none
              ]
            ),
          macaroon: @alice_macaroon,
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
        Lightnex.connect(@bob_address,
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: @bob_tls_cert,
                verify: :verify_none
              ]
            ),
          macaroon: @bob_macaroon,
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
        Lightnex.connect(@alice_address,
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: @alice_tls_cert,
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
        Lightnex.connect(@alice_address,
          cred:
            GRPC.Credential.new(
              ssl: [
                cacertfile: @alice_tls_cert,
                verify: :verify_none
              ]
            ),
          macaroon: @alice_macaroon,
          macaroon_type: :file
        )

      summary = Conn.summary(conn)
      assert summary.address == @alice_address
      assert summary.authenticated == true
      assert is_integer(summary.timeout)
      assert %DateTime{} = summary.connected_at
      assert summary.node_alias == "alice"
      assert is_binary(summary.node_pubkey)

      {:ok, _} = Lightnex.disconnect(conn)
    end
  end
end
