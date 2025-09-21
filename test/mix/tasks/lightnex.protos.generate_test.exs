defmodule Mix.Tasks.Lightnex.Protos.GenerateTest do
  use ExUnit.Case, async: true
  use Mimic

  import ExUnit.CaptureIO
  import Lightnex.TestUtils

  alias Mix.Tasks.Lightnex.Protos.Generate

  setup do
    {:ok, input_dir: Briefly.create!(type: :directory)}
  end

  describe "run/1" do
    test "validates proto files exist before generation" do
      with_tmp_dir(fn tmp_dir ->
        empty_dir = Path.join(tmp_dir, "empty")
        File.mkdir_p!(empty_dir)

        output =
          capture_io(fn ->
            assert_raise Mix.Error, ~r/Proto directory not found/, fn ->
              Generate.run(["-i", "nonexistent", "-o", tmp_dir])
            end
          end)

        assert output == ""
      end)
    end

    test "validates all required proto files are present", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        # Create all proto files except one
        create_mock_proto_files(input_dir)
        remove_proto_file(input_dir, "lightning.proto")

        output =
          capture_io(fn ->
            assert_raise Mix.Error, ~r/Missing proto files/, fn ->
              Generate.run(["-i", input_dir, "-o", output_dir])
            end
          end)

        assert output == ""
      end)
    end

    test "creates output directory if it doesn't exist", %{input_dir: input_dir} do
      with_tmp_dir(fn tmp_dir ->
        create_mock_proto_files(input_dir)
        new_output_dir = Path.join(tmp_dir, "new")
        refute File.exists?(new_output_dir)

        mock_successful_protoc()

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", new_output_dir])
          end)

        assert output =~ "✅ Code generation completed successfully!"

        assert File.exists?(new_output_dir)
      end)
    end

    test "cleans output directory when --clean flag is used", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)

        # Create some existing files
        existing_file = Path.join(output_dir, "existing.pb.ex")
        File.write!(existing_file, "old content")
        assert File.exists?(existing_file)

        mock_successful_protoc()

        capture_io(fn ->
          Generate.run(["-i", input_dir, "-o", output_dir, "--clean", "-v"])
        end)

        refute File.exists?(existing_file)
      end)
    end

    test "generates protobuf modules successfully", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_successful_protoc_with_file_creation(output_dir)

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir])
          end)

        assert output =~ "⚙️ Generating Elixir modules from protobuf files"
        assert output =~ "🔧 Generating protobuf modules..."
        assert output =~ "✅ Protobuf modules generated"
        assert output =~ "✅ Code generation completed successfully!"
      end)
    end

    test "includes documentation when --include-docs flag is used", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)

        System
        |> expect(:find_executable, fn
          "protoc" -> "/usr/bin/protoc"
          cmd -> System.find_executable(cmd)
        end)
        |> expect(:cmd, fn "protoc", args, _opts ->
          # Verify that include_docs option is passed
          args_string = Enum.join(args, " ")
          assert args_string =~ "include_docs=true"
          {"", 0}
        end)

        mock_mix_format()

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir, "--include-docs"])
          end)

        assert output =~ "Generating Elixir modules"
      end)
    end

    test "shows verbose output when --verbose flag is used", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_successful_protoc_with_file_creation(output_dir)

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir, "--verbose"])
          end)

        assert output =~ "▶️ Running: protoc"
        assert output =~ "🔄 Transforming files"
      end)
    end

    test "transforms module namespaces correctly", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_successful_protoc_with_transformation(output_dir)

        capture_io(fn ->
          Generate.run(["-i", input_dir, "-o", output_dir, "-v"])
        end)

        # Check that generated files have transformed content
        lightning_file = Path.join(output_dir, "lightning.pb.ex")
        assert File.exists?(lightning_file)

        assert_namespace_transformation(
          lightning_file,
          "Lnrpc",
          "Lightnex.LNRPC.Lightning"
        )
      end)
    end

    test "transforms module namespaces fails reading the file", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_successful_protoc_with_transformation(output_dir)

        File
        |> expect(:read, fn _path ->
          {:error, :enoent}
        end)

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir, "-v"])
          end)

        assert output =~ "❌ Failed to read lightning.pb.ex: enoent"
      end)
    end

    test "transforms module namespaces fails writing the file", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_successful_protoc_with_transformation(output_dir)

        File
        |> expect(:write, fn _path, _content ->
          {:error, :enoent}
        end)

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir, "-v"])
          end)

        assert output =~ "❌ Write failed: enoent"
      end)
    end

    test "lists generated files", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_successful_protoc_with_file_creation(output_dir)

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir])
          end)

        assert output =~ "📁 Generated files:"
        assert output =~ "lightning.pb.ex"
      end)
    end

    test "handles protoc compilation errors", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_protoc_failure()

        output =
          capture_io(fn ->
            assert_raise Mix.Error, ~r/Protobuf generation failed/, fn ->
              Generate.run(["-i", input_dir, "-o", output_dir])
            end
          end)

        assert output =~ "❌ Failed to generate protobuf modules"
      end)
    end

    test "checks for protoc availability", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_missing_protoc()

        capture_io(fn ->
          assert_raise Mix.Error, ~r/protoc compiler not found/, fn ->
            Generate.run(["-i", input_dir, "-o", output_dir])
          end
        end)
      end)
    end

    test "formats generated code", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)
        mock_successful_protoc_with_file_creation(output_dir)

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir, "-v"])
          end)

        assert output =~ "✨ Formatting generated code"
      end)
    end
  end

  describe "module transformation" do
    test "transforms lightning.pb.ex namespaces correctly", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)

        # Create a mock generated file with original namespaces
        original_content = """
        defmodule Lnrpc.GetInfoRequest do
          use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
        end

        defmodule Lnrpc.Lightning.Service do
          use GRPC.Service, name: "lnrpc.Lightning"
          rpc :GetInfo, Lnrpc.GetInfoRequest, Lnrpc.GetInfoResponse
        end
        """

        mock_protoc_with_custom_content(output_dir, "lightning.pb.ex", original_content)

        capture_io(fn ->
          Generate.run(["-i", input_dir, "-o", output_dir])
        end)

        content = File.read!(Path.join(output_dir, "lightning.pb.ex"))
        assert content =~ "defmodule Lightnex.LNRPC.Lightning.GetInfoRequest"
        assert content =~ "use GRPC.Service, name: \"lnrpc.Lightning\""
        refute content =~ "defmodule Lnrpc."
      end)
    end

    test "transforms walletunlocker.pb.ex namespaces correctly", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)

        original_content = """
        defmodule Lnrpc.InitWalletRequest do
          use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
          field :channel_backups, 5, type: Lnrpc.ChanBackupSnapshot
        end

        defmodule WalletUnlocker.WalletUnlocker.Service do
          use GRPC.Service, name: "lnrpc.WalletUnlocker"
        end
        """

        mock_protoc_with_custom_content(output_dir, "walletunlocker.pb.ex", original_content)

        capture_io(fn ->
          Generate.run(["-i", input_dir, "-o", output_dir])
        end)

        content = File.read!(Path.join(output_dir, "walletunlocker.pb.ex"))
        assert content =~ "defmodule Lightnex.LNRPC.WalletUnlocker.InitWalletRequest"
        assert content =~ "type: Lightnex.LNRPC.Lightning.ChanBackupSnapshot"
        assert content =~ "use GRPC.Service, name: \"lnrpc.WalletUnlocker\""
      end)
    end

    test "handles files with no transformations needed", %{input_dir: input_dir} do
      with_tmp_dir(fn output_dir ->
        create_mock_proto_files(input_dir)

        unchanged_content = """
        defmodule SomeOther.Module do
          use Protobuf
        end
        """

        mock_protoc_with_custom_content(output_dir, "unknown.pb.ex", unchanged_content)

        output =
          capture_io(fn ->
            Generate.run(["-i", input_dir, "-o", output_dir, "--verbose"])
          end)

        assert output =~ "- unknown.pb.ex (no changes)"
      end)
    end
  end

  # Helper functions for mocking using Mimic
  defp mock_successful_protoc do
    System
    |> expect(:find_executable, fn
      "protoc" -> "/usr/bin/protoc"
      cmd -> System.find_executable(cmd)
    end)
    |> expect(:cmd, fn "protoc", _args, _opts ->
      {"", 0}
    end)

    mock_mix_format()
  end

  defp mock_successful_protoc_with_file_creation(output_dir) do
    System
    |> expect(:find_executable, fn
      "protoc" -> "/usr/bin/protoc"
      cmd -> System.find_executable(cmd)
    end)
    |> expect(:cmd, fn "protoc", _args, _opts ->
      create_mock_generated_files(output_dir)
      {"", 0}
    end)

    mock_mix_format()
  end

  defp mock_successful_protoc_with_transformation(output_dir) do
    System
    |> expect(:find_executable, fn
      "protoc" -> "/usr/bin/protoc"
      cmd -> System.find_executable(cmd)
    end)
    |> expect(:cmd, fn "protoc", _args, _opts ->
      content = default_generated_content()
      File.write!(Path.join(output_dir, "lightning.pb.ex"), content)
      {"ok", 0}
    end)

    mock_mix_format()
  end

  defp mock_protoc_with_custom_content(output_dir, filename, content) do
    System
    |> expect(:find_executable, fn
      "protoc" -> "/usr/bin/protoc"
      cmd -> System.find_executable(cmd)
    end)
    |> expect(:cmd, fn "protoc", _args, _opts ->
      File.write!(Path.join(output_dir, filename), content)
      {"", 0}
    end)

    mock_mix_format()
  end

  defp mock_protoc_failure do
    System
    |> expect(:find_executable, fn
      "protoc" -> "/usr/bin/protoc"
      cmd -> System.find_executable(cmd)
    end)
    |> expect(:cmd, fn "protoc", _args, _opts ->
      {"Error: invalid proto file", 1}
    end)
  end

  defp mock_missing_protoc do
    System
    |> expect(:find_executable, fn
      "protoc" -> nil
      cmd -> System.find_executable(cmd)
    end)
  end

  defp mock_mix_format do
    Mix.Lightnex
    |> expect(:format_code, fn -> :ok end)
  end
end
