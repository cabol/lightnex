defmodule Lightnex.WalletHelper do
  @moduledoc """
  Helper module for automated LND wallet creation and unlocking in tests.
  Works in CI/CD environments without manual intervention.
  """

  alias Lightnex.LNRPC.WalletUnlocker

  @wallet_password "integration_test_password_123"
  @max_retries 60
  @retry_delay 1_000

  @doc """
  Ensures an LND node's wallet is created and unlocked.
  Automatically handles:

    - Creating wallet if it doesn't exist
    - Unlocking wallet if it's locked
    - Waiting for LND to be ready

  """
  def ensure_wallet_ready(address, tls_cert, node_name) do
    cred = build_credentials(tls_cert)

    case check_wallet_status(address, cred) do
      :ready ->
        IO.puts("✅ #{node_name} wallet already ready")
        {:ok, :already_ready}

      :locked ->
        IO.puts("🔓 Unlocking #{node_name} wallet...")
        unlock_wallet(address, cred)
        wait_for_ready(address, cred, node_name)
        {:ok, :unlocked}

      :not_created ->
        IO.puts("🔑 Creating #{node_name} wallet...")
        create_wallet(address, cred, node_name)
        wait_for_ready(address, cred, node_name)
        {:ok, :created}
    end
  end

  defp build_credentials(tls_cert) do
    GRPC.Credential.new(
      ssl: [
        cacertfile: tls_cert,
        verify: :verify_none
      ]
    )
  end

  defp check_wallet_status(address, cred, retries \\ @max_retries) do
    case GRPC.Stub.connect(address, cred: cred) do
      {:ok, channel} ->
        status = determine_status(channel)
        GRPC.Stub.disconnect(channel)
        status

      {:error, _} when retries > 0 ->
        Process.sleep(@retry_delay)
        check_wallet_status(address, cred, retries - 1)

      {:error, reason} ->
        raise "Failed to connect to LND at #{address}: #{inspect(reason)}"
    end
  end

  defp determine_status(channel) do
    # Try Lightning.GetInfo first - if it works, wallet is ready
    request = %Lightnex.LNRPC.Lightning.GetInfoRequest{}

    case Lightnex.LNRPC.Lightning.Stub.get_info(channel, request) do
      {:ok, _} ->
        :ready

      {:error, %GRPC.RPCError{status: 2, message: msg}} ->
        # Status 2 (UNKNOWN) can mean different things
        cond do
          msg =~ "wallet locked" -> :locked
          msg =~ "wallet not found" -> :not_created
          msg =~ "unlocked" -> :ready
          msg =~ "expected 1 macaroon" -> :ready
          true -> :not_created
        end

      {:error, %GRPC.RPCError{status: 12}} ->
        # Status 12 (UNIMPLEMENTED) means WalletUnlocker service is active
        # This indicates wallet doesn't exist yet
        :not_created

      {:error, %GRPC.RPCError{status: 14}} ->
        # Status 14 (UNAVAILABLE) - service not ready yet
        :not_created

      {:error, _} ->
        :not_created
    end
  end

  defp create_wallet(address, cred, node_name) do
    {:ok, channel} = GRPC.Stub.connect(address, cred: cred)

    # Step 1: Generate a new seed
    IO.puts("  Generating seed for #{node_name}...")
    gen_seed_request = %WalletUnlocker.GenSeedRequest{}

    case WalletUnlocker.Stub.gen_seed(channel, gen_seed_request) do
      {:ok, response} ->
        IO.puts("  ✓ Seed generated (#{length(response.cipher_seed_mnemonic)} words)")
        # Continue to step 2
        initialize_wallet(channel, response.cipher_seed_mnemonic, node_name)

      {:error, %GRPC.RPCError{status: 2, message: msg}} ->
        GRPC.Stub.disconnect(channel)

        if msg =~ "already unlocked" do
          # Wallet is already unlocked, we're done
          IO.puts("  ✓ Wallet already exists and is unlocked")
          :ok
        else
          raise "Failed to generate seed: #{inspect(%GRPC.RPCError{status: 2, message: msg})}"
        end

      {:error, reason} ->
        GRPC.Stub.disconnect(channel)
        raise "Failed to generate seed: #{inspect(reason)}"
    end
  end

  defp initialize_wallet(channel, seed_mnemonic, node_name) do
    # Step 2: Create wallet with the generated seed
    IO.puts("  Initializing wallet for #{node_name}...")

    init_request = %WalletUnlocker.InitWalletRequest{
      wallet_password: @wallet_password,
      cipher_seed_mnemonic: seed_mnemonic,
      recovery_window: 0
    }

    case WalletUnlocker.Stub.init_wallet(channel, init_request) do
      {:ok, _response} ->
        GRPC.Stub.disconnect(channel)
        IO.puts("  ✓ Wallet created, waiting for LND to restart...")
        # LND restarts after wallet creation, wait longer
        Process.sleep(5000)
        :ok

      {:error, %GRPC.RPCError{message: msg} = reason} ->
        GRPC.Stub.disconnect(channel)

        if msg =~ "already exists" or msg =~ "already unlocked" do
          # Wallet already exists, that's fine
          IO.puts("  ✓ Wallet already exists")
          :ok
        else
          raise "Failed to create wallet: #{inspect(reason)}"
        end
    end
  end

  defp unlock_wallet(address, cred) do
    {:ok, channel} = GRPC.Stub.connect(address, cred: cred)

    request = %WalletUnlocker.UnlockWalletRequest{
      wallet_password: @wallet_password
    }

    case WalletUnlocker.Stub.unlock_wallet(channel, request) do
      {:ok, _response} ->
        GRPC.Stub.disconnect(channel)
        IO.puts("  ✓ Wallet unlocked")
        # Wait for LND to finish unlocking
        Process.sleep(2000)
        :ok

      {:error, %GRPC.RPCError{message: msg} = reason} ->
        GRPC.Stub.disconnect(channel)

        cond do
          msg =~ "invalid passphrase" ->
            raise """
            Wallet exists but password doesn't match.
            This might be a leftover wallet from a previous test run.

            To fix this, run:
            docker compose -f docker/docker-compose.yml down -v
            rm -rf docker/data/*

            Then restart your tests.
            """

          msg =~ "wallet not found" ->
            raise """
            Tried to unlock wallet but it doesn't exist yet.
            This shouldn't happen - please report this as a bug.
            """

          true ->
            raise "Failed to unlock wallet: #{inspect(reason)}"
        end
    end
  end

  defp wait_for_ready(address, cred, node_name, retries \\ @max_retries) do
    status = check_wallet_status(address, cred, 1)

    case status do
      :ready ->
        IO.puts("✅ #{node_name} is ready")
        :ok

      other_status when retries > 0 ->
        if rem(retries, 10) == 0 do
          IO.puts(
            "  Waiting for #{node_name}... (status: #{other_status}, #{retries}s remaining)"
          )
        end

        Process.sleep(@retry_delay)
        wait_for_ready(address, cred, node_name, retries - 1)

      other_status ->
        raise """
        #{node_name} wallet not ready after #{@max_retries} seconds.
        Last status: #{other_status}

        This could mean:
        - LND is taking longer than expected to start
        - There's an issue with the LND configuration
        - The wallet was created but LND failed to restart properly

        Check the Docker logs:
        docker logs lightnex-lnd-#{String.downcase(node_name)}
        """
    end
  end
end
