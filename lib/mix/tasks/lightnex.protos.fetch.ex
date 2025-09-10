defmodule Mix.Tasks.Lightnex.Protos.Fetch do
  @shortdoc "Download LND protobuf files from GitHub"

  @moduledoc """
  Downloads LND protobuf files from GitHub.

  The protobuf files will be placed in the `priv/protos` directory.

  ## Examples

      $ mix lightnex.protos.fetch -v 0.19.3-beta

  ## Command line options

    * `-v`, `--version` - The LND version to download.
    * `-o`, `--output-dir` - Directory where protobuf files will be placed.

  """

  use Mix.Task

  alias Mint.HTTP

  import Mix.Lightnex

  # Specify the LND version you want
  @lnd_version "v0.19.3-beta"
  @base_url "https://raw.githubusercontent.com/lightningnetwork/lnd"

  @output_dir "priv/protos"

  @switches [
    version: :string,
    output_dir: :string
  ]

  @aliases [
    v: :version,
    o: :output_dir
  ]

  @impl true
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: @switches, aliases: @aliases)

    version = Keyword.get(opts, :version, @lnd_version)
    output_dir = Keyword.get(opts, :output_dir, @output_dir)

    # Ensure directory exists and create subdirectories for nested protos
    File.mkdir_p!(output_dir)
    create_subdirectories(output_dir)

    Mix.shell().info("⬇️ Downloading LND proto files (version: #{version})...")

    # Download all proto files
    Enum.each(proto_files(), fn proto_file ->
      download_proto_file(version, proto_file, output_dir)
    end)

    Mix.shell().info("✅ All proto files downloaded successfully!")
    Mix.shell().info("👉 Run 'mix lightnex.protos.generate' to generate Elixir modules.")
  end

  defp create_subdirectories(output_dir) do
    proto_files()
    |> Enum.map(&Path.dirname(&1))
    |> Enum.uniq()
    |> Enum.reject(&(&1 == "." or &1 == ""))
    |> Enum.each(fn subdir ->
      File.mkdir_p!(Path.join(output_dir, subdir))
    end)
  end

  defp download_proto_file(version, proto_file, dest_path) do
    url = "#{@base_url}/#{version}/lnrpc/#{proto_file}"
    dest_file = Path.join(dest_path, proto_file)

    case http_get(url) do
      {:ok, body} ->
        # Ensure the directory for the file exists
        dest_file |> Path.dirname() |> File.mkdir_p!()
        File.write!(dest_file, body)
        Mix.shell().info("   #{proto_file} ✅")

      {:error, reason} ->
        Mix.shell().info("   #{proto_file} ❌ (#{inspect(reason)})")
        Mix.raise("Failed to download #{proto_file}: #{inspect(reason)}")
    end
  end

  defp http_get(url) do
    uri = URI.parse(url)
    scheme = String.to_atom(uri.scheme)
    port = uri.port

    with {:ok, conn} <- HTTP.connect(scheme, uri.host, port),
         {:ok, conn, request_ref} <- HTTP.request(conn, "GET", uri.path, [], ""),
         {:ok, response} <-
           receive_response(conn, request_ref, %{status: nil, headers: [], body: ""}) do
      HTTP.close(conn)

      case response.status do
        200 ->
          {:ok, response.body}

        # coveralls-ignore-start
        status ->
          {:error, "HTTP #{status}"}
          # coveralls-ignore-stop
      end
    end
  end

  defp receive_response(conn, request_ref, response) do
    receive do
      message -> stream_response(conn, request_ref, response, message)
    after
      # coveralls-ignore-start
      30_000 ->
        {:error, :timeout}
        # coveralls-ignore-stop
    end
  end

  defp stream_response(conn, request_ref, response, message) do
    case HTTP.stream(conn, message) do
      {:ok, conn, responses} ->
        response =
          Enum.reduce(responses, response, fn
            {:status, ^request_ref, status}, acc ->
              %{acc | status: status}

            {:headers, ^request_ref, headers}, acc ->
              %{acc | headers: headers ++ acc.headers}

            {:data, ^request_ref, data}, acc ->
              %{acc | body: acc.body <> data}

            {:done, ^request_ref}, acc ->
              acc

            _other, acc ->
              # coveralls-ignore-start
              acc
              # coveralls-ignore-stop
          end)

        if Enum.any?(responses, &match?({:done, ^request_ref}, &1)) do
          {:ok, response}
        else
          # coveralls-ignore-start
          receive_response(conn, request_ref, response)
          # coveralls-ignore-stop
        end

      {:error, _conn, reason, _responses} ->
        {:error, reason}

      # coveralls-ignore-start
      :unknown ->
        {:error, :unknown_message}
        # coveralls-ignore-stop
    end
  end
end
