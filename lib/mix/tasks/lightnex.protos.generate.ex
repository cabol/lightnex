defmodule Mix.Tasks.Lightnex.Protos.Generate do
  @shortdoc "Generate Elixir modules from LND protobuf files"

  @moduledoc """
  Generates Elixir modules from LND protobuf files.

  This task reads the protobuf files from `priv/protos` directory and generates
  corresponding Elixir modules in the `lib/lightnex/rpc` directory.

  The generated modules include:
  - Protobuf message definitions
  - gRPC service stubs and clients

  ## Examples

      $ mix lightnex.protos.generate
      $ mix lightnex.protos.generate --include-docs

  ## Command line options

    * `-i`, `--input-dir` - Directory where protobuf files are located
      (default: `priv/protos`).
    * `-o`, `--output-dir` - Directory where generated modules will be placed
      (default: `lib/lightnex/rpc`).
    * `-d`, `--include-docs` - Include documentation in generated code.
    * `-c`, `--clean` - Clean output directory before generating.
    * `-v`, `--verbose` - Show verbose output.

  """

  use Mix.Task

  import Mix.Lightnex, only: [proto_files: 0]

  @input_dir "priv/protos"
  @output_dir "lib/lightnex/rpc"

  @switches [
    input_dir: :string,
    output_dir: :string,
    clean: :boolean,
    include_docs: :boolean,
    verbose: :boolean
  ]

  @aliases [
    i: :input_dir,
    o: :output_dir,
    c: :clean,
    d: :include_docs,
    v: :verbose
  ]

  @impl true
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: @switches, aliases: @aliases)

    proto_path = Keyword.get(opts, :input_dir, @input_dir)
    output_dir = Keyword.get(opts, :output_dir, @output_dir)
    clean? = Keyword.get(opts, :clean, false)
    verbose? = Keyword.get(opts, :verbose, false)
    include_docs? = Keyword.get(opts, :include_docs, false)

    # Validate proto files exist
    validate_proto_files(proto_path)

    # Clean output directory if requested
    if clean? do
      clean_output_dir(output_dir, verbose?)
    end

    # Ensure output directory exists
    File.mkdir_p!(output_dir)

    Mix.shell().info("""

    ⚙️ Generating Elixir modules from protobuf files...
       Proto path: #{proto_path}
       Output dir: #{output_dir}
    """)

    # Check if protoc is available
    ensure_protoc_available()

    # Generate protobuf and gRPC modules
    generate_protobuf_modules(proto_path, output_dir, include_docs?, verbose?)

    # Transform modules
    transform_modules(output_dir, verbose: verbose?)

    # Format code
    format_code(verbose?)

    # List generated files
    list_generated_files(output_dir)

    Mix.shell().info("""

    ✅ Code generation completed successfully!

    👉 Add the following to your application:
       alias Lightnex.RPC.Lightning.{GetInfoRequest, GetInfoResponse}
       alias Lightnex.RPC.WalletUnlocker.{InitWalletRequest, UnlockWalletRequest}
    """)
  end

  defp validate_proto_files(proto_path) do
    unless File.dir?(proto_path) do
      Mix.raise("""
      Proto directory not found: #{proto_path}

      Run 'mix lightnex.protos.fetch' first to download the protobuf files.
      """)
    end

    missing_files =
      proto_files()
      |> Enum.reject(fn file ->
        proto_file_path = Path.join(proto_path, file)
        File.exists?(proto_file_path)
      end)

    unless Enum.empty?(missing_files) do
      Mix.raise("""
      Missing proto files: #{Enum.join(missing_files, ", ")}

      Run 'mix lightnex.protos.fetch' to download missing files.
      """)
    end
  end

  defp clean_output_dir(output_dir, verbose?) do
    if File.dir?(output_dir) do
      if verbose? do
        Mix.shell().info("🧹 Cleaning output directory: #{output_dir}")
      end

      File.rm_rf!(output_dir)
    end
  end

  defp ensure_protoc_available do
    case System.find_executable("protoc") do
      nil ->
        Mix.raise("""
        protoc compiler not found!

        Please install the Protocol Buffers compiler:

        macOS:   brew install protobuf
        Ubuntu:  apt-get install protobuf-compiler
        Arch:    pacman -S protobuf

        Or download from: https://github.com/protocolbuffers/protobuf/releases
        """)

      _path ->
        :ok
    end
  end

  defp generate_protobuf_modules(proto_path, output_dir, include_docs?, verbose?) do
    Mix.shell().info("🔧 Generating protobuf modules...")

    proto_args =
      if include_docs? do
        [
          "--elixir_out=plugins=grpc:#{output_dir}",
          "--elixir_opt=include_docs=#{include_docs?}",
          "--proto_path=#{proto_path}"
        ]
      else
        [
          "--elixir_out=plugins=grpc:#{output_dir}",
          "--proto_path=#{proto_path}"
        ]
      end

    protoc_args = proto_args ++ Enum.map(proto_files(), &Path.join(proto_path, &1))

    if verbose? do
      Mix.shell().info("   ▶️ Running: protoc #{Enum.join(protoc_args, " ")}")
    end

    case System.cmd("protoc", protoc_args, stderr_to_stdout: true) do
      {output, 0} ->
        if verbose? and String.trim(output) != "" do
          Mix.shell().info("protoc output: #{output}")
        end

        Mix.shell().info("   ✅ Protobuf modules generated")

      {error_output, exit_code} ->
        Mix.shell().info("""

          ❌ Failed to generate protobuf modules (exit code: #{exit_code})
          Error output:
          #{error_output}
        """)

        Mix.raise("Protobuf generation failed")
    end
  end

  defp list_generated_files(output_dir) do
    generated_files =
      output_dir
      |> Path.join("**/*.pb.ex")
      |> Path.wildcard()
      |> Enum.map(&Path.relative_to(&1, output_dir))
      |> Enum.sort()

    unless Enum.empty?(generated_files) do
      Mix.shell().info("""
      📁 Generated files:
      """)

      Enum.each(generated_files, fn file ->
        Mix.shell().info([:green, "  - #{output_dir}/#{file}"])
      end)
    end
  end

  defp format_code(verbose?) do
    if verbose? do
      Mix.shell().info("""

      ✨ Formatting generated code...
      """)
    end

    Mix.Lightnex.format_code()
  end

  ## Module transformation

  # Define all the LND RPC packages that need to be unified
  @lnd_packages %{
    "lightning.pb.ex" => [
      {"Lnrpc", "Lightnex.RPC.Lightning"},
      {"Lightning.Lightning", "Lightning"}
    ],
    "stateservice.pb.ex" => [{"Lnrpc", "Lightnex.RPC.State"}],
    "walletunlocker.pb.ex" => [
      {"Lnrpc.ChanBackupSnapshot", "Lightnex.RPC.Lightning.ChanBackupSnapshot"},
      {"Lnrpc", "Lightnex.RPC.WalletUnlocker"},
      {"WalletUnlocker.WalletUnlocker", "WalletUnlocker"}
    ],
    "chainnotifier.pb.ex" => [
      {"Chainrpc", "Lightnex.RPC.ChainNotifier"},
      {"ChainNotifier.ChainNotifier", "ChainNotifier"}
    ],
    "chainkit.pb.ex" => [{"Chainrpc", "Lightnex.RPC.ChainKit"}, {"ChainKit.ChainKit", "ChainKit"}],
    "invoices.pb.ex" => [
      {"Invoicesrpc", "Lightnex.RPC.Invoices"},
      {"Invoices.Invoices", "Invoices"},
      {"Lnrpc", "Lightnex.RPC.Lightning"}
    ],
    "peers.pb.ex" => [
      {"Peersrpc", "Lightnex.RPC.Peers"},
      {"Peers.Peers", "Peers"},
      {"Lnrpc", "Lightnex.RPC.Lightning"}
    ],
    "router.pb.ex" => [
      {"Routerrpc", "Lightnex.RPC.Router"},
      {"Router.Router", "Router"},
      {"Lnrpc", "Lightnex.RPC.Lightning"}
    ],
    "signer.pb.ex" => [{"Signrpc", "Lightnex.RPC.Signer"}, {"Signer.Signer", "Signer"}],
    "walletkit.pb.ex" => [
      {"Walletrpc", "Lightnex.RPC.WalletKit"},
      {"WalletKit.WalletKit", "WalletKit"},
      {"Lnrpc", "Lightnex.RPC.Lightning"},
      {"Signrpc", "Lightnex.RPC.Signer"}
    ],
    "watchtower.pb.ex" => [
      {"Watchtowerrpc", "Lightnex.RPC.Watchtower"},
      {"Watchtower.Watchtower", "Watchtower"}
    ],
    "wtclient.pb.ex" => [
      {"Wtclientrpc", "Lightnex.RPC.WatchtowerClient"},
      {"WatchtowerClient.WatchtowerClient", "WatchtowerClient"}
    ]
  }

  defp transform_modules(output_dir, opts) do
    verbose? = Keyword.get(opts, :verbose, false)

    case find_protobuf_files(output_dir) do
      [] ->
        {:error, "No .pb.ex files found in #{output_dir}"}

      files ->
        stats = process_files(files, verbose?)

        {:ok, stats}
    end
  end

  # Find all protobuf files in the directory
  defp find_protobuf_files(output_dir) do
    output_dir
    |> Path.join("**/*.pb.ex")
    |> Path.wildcard()
    |> Enum.sort()
  end

  # Process each file and collect statistics
  defp process_files(files, verbose?) do
    if verbose?, do: Mix.shell().info("\r\n🔄 Transforming files...")

    results = Enum.map(files, &process_file(&1, verbose?))

    stats = %{
      files_processed: length(files),
      files_changed: Enum.count(results, & &1),
      transformations: count_transformations(results)
    }

    if verbose? do
      Mix.shell().info("   ✅ #{stats.files_changed}/#{stats.files_processed} files transformed")
    end

    stats
  end

  # Process a single file
  defp process_file(file_path, verbose?) do
    relative_path = Path.basename(file_path)

    case File.read(file_path) do
      {:ok, original_content} ->
        transformations = Map.get(@lnd_packages, relative_path, [])
        transformed_content = transform_content(transformations, original_content)

        process_content(file_path, relative_path, original_content, transformed_content, verbose?)

      {:error, reason} ->
        if verbose?, do: Mix.shell().info("   ❌ Failed to read #{relative_path}: #{reason}")

        false
    end
  end

  defp process_content(file_path, relative_path, original_content, transformed_content, verbose?) do
    if original_content != transformed_content do
      if verbose?, do: Mix.shell().info("   📝 #{relative_path}")

      write_file(file_path, transformed_content, verbose?)
    else
      if verbose?, do: Mix.shell().info("   - #{relative_path} (no changes)")

      false
    end
  end

  defp write_file(file_path, transformed_content, verbose?) do
    case File.write(file_path, transformed_content) do
      :ok ->
        if verbose?, do: Mix.shell().info("      ✓ Written")

        true

      {:error, reason} ->
        if verbose?, do: Mix.shell().info("      ❌ Write failed: #{reason}")

        false
    end
  end

  # Transform the content of a single file
  defp transform_content(transformations, content) do
    transformations
    |> Enum.reduce(content, fn {old_namespace, target_namespace}, acc ->
      transform_namespace_in_content(acc, old_namespace, target_namespace)
    end)
  end

  # Transform a specific namespace in the content
  defp transform_namespace_in_content(content, old_namespace, new_namespace) do
    transformations = [
      # Module definitions
      {"defmodule #{old_namespace}.", "defmodule #{new_namespace}."},

      # Type annotations and field types
      {"type: #{old_namespace}", "type: #{new_namespace}"},

      # Direct module references
      {"#{old_namespace}.", "#{new_namespace}."},

      # Alias statements
      {"alias #{old_namespace}", "alias #{new_namespace}"},

      # Use statements (less common but possible)
      {"use #{old_namespace}", "use #{new_namespace}"},

      # GRPC service definitions
      {"service: #{old_namespace}", "service: #{new_namespace}"},

      # Enum references in protobuf
      {"enum: #{old_namespace}", "enum: #{new_namespace}"},

      # Import statements (if any)
      {"import #{old_namespace}", "import #{new_namespace}"}
    ]

    Enum.reduce(transformations, content, fn {pattern, replacement}, acc ->
      String.replace(acc, pattern, replacement)
    end)
  end

  # Count how many transformations were made (for statistics)
  defp count_transformations(results) do
    # This is a simplified count - you could make it more detailed
    Enum.count(results, & &1)
  end
end
