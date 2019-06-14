defmodule Configurable.MixProject do
  use Mix.Project

  def project do
    [
      app: :configurable,
      version: "0.1.0",
      elixir: "~> 1.9-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Configurable.Application, []}
    ]
  end

  defp deps do
    []
  end
end
