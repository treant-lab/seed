defmodule Seed.MixProject do
  use Mix.Project

  def project do
    [
      app: :seed,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      config_path: "./config/config.exs"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    # [
    #   mod: {Seed.Application, []},
    #   extra_applications: [:logger, :rsa_ex]
    # ]
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rsa_ex, "~> 0.4"},
      {:joken, "~> 2.6.0"},
      {:seraph, "~> 0.2.0"},
      {:bcrypt_elixir, "~> 3.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 0.5", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
