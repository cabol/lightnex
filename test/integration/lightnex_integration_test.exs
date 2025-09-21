defmodule LightnexIntegrationTest do
  # These tests require Docker containers to be running
  # Run with: mix test --only integration
  use ExUnit.Case, async: false
  @moduletag :integration

  # alias Lightnex.Conn

  # @alice_address "localhost:10009"
  # @bob_address "localhost:10010"

  # setup_all do
  #   # Wait for containers to be ready
  #   wait_for_lnd(@alice_address)
  #   wait_for_lnd(@bob_address)

  #   :ok
  # end

  # describe "real LND connection" do
  #   test "connect to Alice node without authentication" do
  #     assert {:ok, %Conn{} = conn} = Lightnex.connect(@alice_address, validate: false)
  #     assert conn.address == @alice_address
  #     refute Conn.authenticated?(conn)

  #     # Should have node info from validation
  #     assert is_map(conn.node_info)
  #     assert conn.node_info[:alias] == "alice"

  #     # Clean up
  #     :ok = Lightnex.disconnect(conn)
  #   end

  #   test "connect to Bob node without authentication" do
  #     assert {:ok, %Conn{} = conn} = Lightnex.connect(@bob_address)
  #     assert conn.address == @bob_address
  #     assert conn.node_info[:alias] == "bob"

  #     :ok = Lightnex.disconnect(conn)
  #   end

  #   test "get_info from Alice" do
  #     {:ok, conn} = Lightnex.connect(@alice_address)

  #     assert {:ok, info} = Lightnex.get_info(conn)
  #     assert is_binary(info.identity_pubkey)
  #     assert info.alias == "alice"
  #     assert is_integer(info.block_height)
  #     assert info.block_height > 0
  #     assert is_boolean(info.synced_to_chain)

  #     :ok = Lightnex.disconnect(conn)
  #   end

  #   test "get_info from Bob" do
  #     {:ok, conn} = Lightnex.connect(@bob_address)

  #     assert {:ok, info} = Lightnex.get_info(conn)
  #     assert is_binary(info.identity_pubkey)
  #     assert info.alias == "bob"

  #     :ok = Lightnex.disconnect(conn)
  #   end

  #   test "connection validation works" do
  #     # This should validate and populate node_info
  #     assert {:ok, %Conn{} = conn} = Lightnex.connect(@alice_address, validate: true)
  #     assert is_map(conn.node_info)
  #     assert conn.node_info[:alias] == "alice"

  #     :ok = Lightnex.disconnect(conn)
  #   end

  #   test "connection without validation" do
  #     # This should not populate node_info
  #     assert {:ok, %Conn{} = conn} = Lightnex.connect(@alice_address, validate: false)
  #     assert is_nil(conn.node_info)

  #     :ok = Lightnex.disconnect(conn)
  #   end

  #   test "connection to invalid address fails" do
  #     assert {:error, _reason} = Lightnex.connect("localhost:99999")
  #   end

  #   test "connection summary includes expected fields" do
  #     {:ok, conn} = Lightnex.connect(@alice_address)

  #     summary = Conn.summary(conn)
  #     assert summary.address == @alice_address
  #     assert summary.authenticated == false
  #     assert is_integer(summary.timeout)
  #     assert %DateTime{} = summary.connected_at
  #     assert summary.node_alias == "alice"
  #     assert is_binary(summary.node_pubkey)

  #     :ok = Lightnex.disconnect(conn)
  #   end
  # end

  # # Helper functions

  # defp wait_for_lnd(address, retries \\ 10) do
  #   case Lightnex.connect(address, validate: false) do
  #     {:ok, conn} ->
  #       Lightnex.disconnect(conn)

  #       :ok

  #     {:error, _} when retries > 0 ->
  #       Process.sleep(1000)

  #       wait_for_lnd(address, retries - 1)

  #     {:error, reason} ->
  #       raise "LND at #{address} not available after 30 seconds: #{inspect(reason)}"
  #   end
  # end
end
