defmodule Mix.Tasks.Lightnex.Protos.FetchTest do
  use ExUnit.Case, async: true
  use Mimic

  import ExUnit.CaptureIO
  import Lightnex.TestUtils

  alias Mix.Tasks.Lightnex.Protos.Fetch

  describe "run/1" do
    test "creates output directory if it doesn't exist" do
      with_tmp_dir(fn tmp_dir ->
        output_dir = Path.join(tmp_dir, "new_dir")
        refute File.exists?(output_dir)

        # Mock successful HTTP requests
        mock_successful_http_requests()

        capture_io(fn -> Fetch.run(["-o", output_dir]) end)

        assert File.exists?(output_dir)
      end)
    end

    test "creates subdirectories for nested proto files" do
      with_tmp_dir(fn tmp_dir ->
        mock_successful_http_requests()

        capture_io(fn ->
          Fetch.run(["-o", tmp_dir])
        end)

        # Check that subdirectories are created
        expected_subdirs = [
          "chainrpc",
          "invoicesrpc",
          "peersrpc",
          "routerrpc",
          "signrpc",
          "walletrpc",
          "watchtowerrpc",
          "wtclientrpc"
        ]

        Enum.each(expected_subdirs, fn subdir ->
          assert File.exists?(Path.join(tmp_dir, subdir))
        end)
      end)
    end

    test "downloads proto files successfully" do
      with_tmp_dir(fn tmp_dir ->
        mock_successful_http_requests()

        output =
          capture_io(fn ->
            Fetch.run(["-o", tmp_dir])
          end)

        # Check output messages
        assert output =~ "⬇️ Downloading LND proto files"
        assert output =~ "lightning.proto ✅"
        assert output =~ "✅ All proto files downloaded successfully!"
        assert output =~ "👉 Run 'mix lightnex.protos.generate'"

        # Check files are created
        assert_files_exist(tmp_dir, [
          "lightning.proto",
          "stateservice.proto",
          "chainrpc/chainkit.proto"
        ])
      end)
    end

    test "handles HTTP errors gracefully" do
      with_tmp_dir(fn tmp_dir ->
        mock_http_failure()

        output =
          capture_io(fn ->
            assert_raise Mix.Error, fn ->
              Fetch.run(["-o", tmp_dir])
            end
          end)

        assert output =~ "lightning.proto ❌"
      end)
    end

    test "handles network timeout" do
      with_tmp_dir(fn tmp_dir ->
        mock_http_timeout()

        output =
          capture_io(fn ->
            assert_raise Mix.Error, fn ->
              Fetch.run(["-o", tmp_dir])
            end
          end)

        assert output =~ "❌"
      end)
    end

    test "uses default output directory when not specified" do
      in_tmp_mix_project(fn _tmp_dir ->
        mock_successful_http_requests()

        capture_io(fn ->
          Fetch.run([])
        end)

        assert File.exists?("priv/protos")
      end)
    end
  end

  # Helper functions for mocking HTTP requests using Mimic
  defp mock_successful_http_requests do
    Mint.HTTP
    # Mock Mint.HTTP.connect
    |> stub(:connect, fn _scheme, _host, _port ->
      {:ok, :mock_conn}
    end)
    # Mock Mint.HTTP.request
    |> stub(:request, fn _conn, _method, _path, _headers, _body ->
      send(self(), {:request, :mock_conn, :mock_request_ref})

      {:ok, :mock_conn, :mock_request_ref}
    end)
    # Mock Mint.HTTP.stream
    |> stub(:stream, fn _conn, _message ->
      proto_content = default_proto_content()

      responses = [
        {:status, :mock_request_ref, 200},
        {:headers, :mock_request_ref, []},
        {:data, :mock_request_ref, proto_content},
        {:done, :mock_request_ref}
      ]

      {:ok, :mock_conn, responses}
    end)
    # Mock Mint.HTTP.close
    |> stub(:close, fn _conn ->
      :ok
    end)
  end

  defp mock_http_failure do
    Mint.HTTP
    |> expect(:connect, fn _scheme, _host, _port ->
      {:error, :connection_failed}
    end)
  end

  defp mock_http_timeout do
    Mint.HTTP
    |> expect(:stream, fn _conn, _message ->
      {:error, :mock_conn, :timeout, []}
    end)
  end
end
