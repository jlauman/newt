defmodule Newt.Mixfile do
  use Mix.Project

  def project do
    [app: :newt,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :timex, :cowboy, :plug],
     mod: {Newt, []}]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:timex, "~> 2.1"},
      {:poison, "~> 2.1"},
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.1"}
    ]
  end
end
