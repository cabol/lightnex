defmodule Lightnex.MixProject do
  use Mix.Project

  @source_url "https://github.com/cabol/lightnex"
  @version "0.1.0"

  def project do
    [
      app: :lightnex,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      consolidate_protocols: Mix.env() != :test,
      aliases: aliases(),
      deps: deps(),

      # Testing
      test_coverage: [tool: ExCoveralls, export: "test-coverage"],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        "test.ci": :test
      ],

      # Dialyzer
      dialyzer: dialyzer(),

      # Hex
      description: "LND (Lightning Network Daemon) client for Elixir",
      package: package(),

      # Docs
      name: "Lightnex",
      docs: docs()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Lightnex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:protobuf, "~> 0.15"},
      {:grpc, "~> 0.10"},
      {:nimble_options, "~> 0.5 or ~> 1.0"},
      {:telemetry, "~> 0.4 or ~> 1.0"},

      # Test & Code Analysis
      {:excoveralls, "~> 0.18", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.14", only: [:dev, :test], runtime: false},
      {:mimic, "~> 2.1", only: :test},
      {:briefly, "~> 0.5", only: :test},
      {:btx, github: "cabol/btx", only: [:dev, :test]},

      # Benchmark Test
      {:benchee, "~> 1.4", only: [:dev, :test]},
      {:benchee_html, "~> 1.0", only: [:dev, :test]},

      # Docs
      {:ex_doc, "~> 0.38", only: [:dev, :test], runtime: false},
      {:usage_rules, "~> 0.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      bench: "run benchmarks/benchmark.exs",
      "test.ci": [
        "deps.unlock --check-unused",
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "coveralls.html",
        "sobelow --skip --exit Low",
        "dialyzer --format short"
      ],
      "lightnex.protos.setup": [
        "lightnex.protos.fetch",
        "lightnex.protos.generate --clean --include-docs --verbose"
      ]
    ]
  end

  defp package do
    [
      name: :nebulex,
      maintainers: [
        "Carlos Bolanos",
        "Felipe Ripoll"
      ],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "#{@source_url}/blob/master/CHANGELOG.md",
        "GitHub" => @source_url
      },
      files: ~w(lib .formatter.exs mix.exs README* CHANGELOG* LICENSE*)
    ]
  end

  defp docs do
    [
      main: "Lightnex",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/btx",
      source_url: @source_url,
      extra_section: "GUIDES",
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: []
    ]
  end

  defp extras do
    [
      # Introduction
      # "guides/introduction/getting-started.md"
    ]
  end

  defp groups_for_extras do
    [
      Introduction: ~r{guides/introduction/[^\/]+\.md},
      Learning: ~r{guides/learning/[^\/]+\.md}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :telemetry, :ex_unit],
      plt_file: {:no_warn, "priv/plts/" <> plt_file_name()},
      flags: [
        :error_handling,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end

  defp plt_file_name do
    "dialyzer-#{Mix.env()}-#{System.version()}-#{System.otp_release()}.plt"
  end
end
