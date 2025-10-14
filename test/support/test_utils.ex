defmodule Lightnex.TestUtils do
  @moduledoc """
  Test helpers for Lightnex Mix tasks.
  """

  use ExUnit.CaseTemplate

  alias ExUnit.CaptureIO

  ## API

  @doc false
  defmacro assert_eventually(retries \\ 50, delay \\ 100, expr) do
    quote do
      unquote(__MODULE__).wait_until(unquote(retries), unquote(delay), fn ->
        unquote(expr)
      end)
    end
  end

  @doc false
  def wait_until(retries \\ 50, delay \\ 100, fun)

  def wait_until(1, _delay, fun), do: fun.()

  def wait_until(retries, delay, fun) when retries > 1 do
    fun.()
  rescue
    _ ->
      :ok = Process.sleep(delay)

      wait_until(retries - 1, delay, fun)
  end

  @doc """
  Creates a temporary directory for tests and ensures cleanup.
  """
  def with_tmp_dir(test_func) when is_function(test_func, 1) do
    tmp_dir = Briefly.create!(type: :directory)
    File.mkdir_p!(tmp_dir)

    try do
      test_func.(tmp_dir)
    after
      File.rm_rf!(tmp_dir)
    end
  end

  @doc """
  Creates mock proto files in the given directory.
  """
  def create_mock_proto_files(dir, content \\ default_proto_content()) do
    proto_files = Mix.Lightnex.proto_files()

    Enum.each(proto_files, fn proto_file ->
      full_path = Path.join(dir, proto_file)
      File.mkdir_p!(Path.dirname(full_path))
      File.write!(full_path, content)
    end)
  end

  @doc """
  Creates mock generated protobuf files.
  """
  def create_mock_generated_files(dir, content \\ default_generated_content()) do
    proto_files = Mix.Lightnex.proto_files()

    generated_files =
      proto_files
      |> Enum.map(&Path.basename(&1, ".proto"))
      |> Enum.map(&"#{&1}.pb.ex")

    Enum.each(generated_files, fn filename ->
      File.write!(Path.join(dir, filename), content)
    end)
  end

  @doc """
  Mocks the protoc command to simulate successful generation.
  """
  def mock_protoc_success do
    fn cmd, _args, _opts ->
      case cmd do
        "protoc" -> {"", 0}
        _ -> :error
      end
    end
  end

  @doc """
  Mocks HTTP requests for fetching proto files.
  """
  def mock_http_success do
    fn url ->
      if String.contains?(url, ".proto") do
        {:ok, default_proto_content()}
      else
        {:error, :not_found}
      end
    end
  end

  @doc """
  Default proto file content for testing.
  """
  def default_proto_content do
    """
    syntax = "proto3";

    package lnrpc;

    service Lightning {
      rpc GetInfo (GetInfoRequest) returns (GetInfoResponse);
    }

    message GetInfoRequest {}
    message GetInfoResponse {
      string version = 1;
    }
    """
  end

  @doc """
  Default generated file content for testing.
  """
  def default_generated_content do
    """
    defmodule Lnrpc.GetInfoRequest do
      use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
    end

    defmodule Lnrpc.GetInfoResponse do
      use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

      field :version, 1, type: :string
    end

    defmodule Lightning.Lightning.Service do
      use GRPC.Service, name: "lnrpc.Lightning", protoc_gen_elixir_version: "0.15.0"

      rpc :GetInfo, Lnrpc.GetInfoRequest, Lnrpc.GetInfoResponse
    end

    defmodule Lightning.Lightning.Stub do
      use GRPC.Stub, service: Lightning.Lightning.Service
    end
    """
  end

  @doc """
  Expected transformed content after namespace transformation.
  """
  def expected_transformed_content do
    """
    defmodule Lightnex.LNRPC.Lightning.GetInfoRequest do
      use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
    end

    defmodule Lightnex.LNRPC.Lightning.GetInfoResponse do
      use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

      field :version, 1, type: :string
    end

    defmodule Lightnex.LNRPC.Lightning.Service do
      use GRPC.Service, name: "lnrpc.Lightning", protoc_gen_elixir_version: "0.15.0"

      rpc :GetInfo, Lightnex.LNRPC.Lightning.GetInfoRequest, Lightnex.LNRPC.Lightning.GetInfoResponse
    end

    defmodule Lightnex.LNRPC.Lightning.Stub do
      use GRPC.Stub, service: Lightnex.LNRPC.Lightning.Service
    end
    """
  end

  @doc """
  Asserts that a directory contains specific files.
  """
  def assert_files_exist(dir, files) when is_list(files) do
    Enum.each(files, fn file ->
      full_path = Path.join(dir, file)

      assert File.exists?(full_path), "Expected file #{file} to exist in #{dir}"
    end)
  end

  @doc """
  Asserts that a directory structure matches expected subdirectories.
  """
  def assert_subdirectories_exist(dir, subdirs) when is_list(subdirs) do
    Enum.each(subdirs, fn subdir ->
      full_path = Path.join(dir, subdir)

      assert File.dir?(full_path), "Expected directory #{subdir} to exist in #{dir}"
    end)
  end

  @doc """
  Captures IO output and returns both the result and the output.
  """
  def capture_io_with_result(fun) do
    output = CaptureIO.capture_io(fun)

    {fun.(), output}
  end

  @doc """
  Simulates running Mix tasks with specific environment.
  """
  def in_tmp_mix_project(test_func) when is_function(test_func, 1) do
    with_tmp_dir(fn tmp_dir ->
      # Create a basic mix.exs file
      mix_exs_content = """
      defmodule TestProject.MixProject do
        use Mix.Project

        def project do
          [
            app: :test_project,
            version: "0.1.0",
            elixir: "~> 1.14",
            deps: deps()
          ]
        end

        defp deps do
          [
            {:protobuf, "~> 0.15"},
            {:grpc, "~> 0.10"}
          ]
        end
      end
      """

      File.write!(Path.join(tmp_dir, "mix.exs"), mix_exs_content)
      File.mkdir_p!(Path.join(tmp_dir, "lib"))

      # Change to the temporary directory for the test
      original_cwd = File.cwd!()
      File.cd!(tmp_dir)

      try do
        test_func.(tmp_dir)
      after
        File.cd!(original_cwd)
      end
    end)
  end

  @doc """
  Creates a mock HTTP response for a specific URL pattern.
  """
  def mock_http_response(url_pattern, response_body) do
    fn url ->
      if String.contains?(url, url_pattern) do
        {:ok, response_body}
      else
        {:error, :not_found}
      end
    end
  end

  @doc """
  Validates that output contains expected success messages.
  """
  def assert_success_output(output) do
    assert output =~ "✅"
    refute output =~ "❌"
    refute output =~ "Error"
  end

  @doc """
  Validates that output contains expected error messages.
  """
  def assert_error_output(output) do
    assert output =~ "❌" or output =~ "Error"
  end

  @doc """
  Creates a specific proto file with custom content.
  """
  def create_proto_file(dir, filename, content \\ default_proto_content()) do
    full_path = Path.join(dir, filename)
    File.mkdir_p!(Path.dirname(full_path))
    File.write!(full_path, content)
    full_path
  end

  @doc """
  Removes a specific proto file (useful for testing missing file scenarios).
  """
  def remove_proto_file(dir, filename) do
    full_path = Path.join(dir, filename)

    if File.exists?(full_path) do
      File.rm!(full_path)
    end
  end

  @doc """
  Asserts that namespace transformation worked correctly.
  """
  def assert_namespace_transformation(file_path, old_namespace, new_namespace) do
    content = File.read!(file_path)

    refute String.contains?(content, "defmodule #{old_namespace}.")
    assert String.contains?(content, "defmodule #{new_namespace}.")
  end

  @doc """
  Creates a test configuration for Mix tasks.
  """
  def test_config(overrides \\ []) do
    default_config = [
      input_dir: "test/tmp/input",
      output_dir: "test/tmp/output",
      version: "v0.19.3-beta",
      verbose: false,
      clean: false,
      include_docs: false
    ]

    Keyword.merge(default_config, overrides)
  end
end
