defmodule Checkout.MixProject do
  use Mix.Project

  def project do
    [
      app: :checkout,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:decimal, "~> 2.0"},
      {:credo, "~> 1.7.8", only: [:dev, :test], runtime: false}
    ]
  end
end
