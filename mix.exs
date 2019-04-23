defmodule Exmarket.MixProject do
  @moduledoc """
  Application entry point and dependency management
  """
  use Mix.Project
  @version "0.1.0"

  def project do
    [
      app: :exmarket,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      description: description(),
      package: package(),
      ## Docs ##
      name: "ExMarket",
      source_url: "https://github.com/EssenceOfChaos/exmarket",
      homepage_url: "",
      # The main page in the docs
      docs: [main: "ExMarket", logo: "assets/images/market-icon.png", extras: ["README.md"]]
    ]
  end

  defp package do
    [
      name: :exmarket,
      maintainers: ["Frederick John"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/EssenceOfChaos/exmarket"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Exmarket.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      ## App Dependencies ##
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1.2"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      clean: [&clean_test_fixtures/1, "clean"],
      build: ["deps.get"],
      setup: []
    ]
  end

  defp description() do
    "ExMarket is a Hex Package designed to provide a clean interface for retrieving real-time stock and crypto data."
  end

  defp clean_test_fixtures(_args) do
    File.rm_rf("test/tmp")
  end
end
