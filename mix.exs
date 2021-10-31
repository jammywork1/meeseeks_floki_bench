defmodule MeeseeksFlokiBench.Mixfile do
  use Mix.Project

  def project do
    [
      app: :meeseeks_floki_bench,
      version: "0.1.1",
      elixir: "~> 1.12",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:benchee, "~> 1.0.1"},
      {:floki, "~> 0.32.0"},
      {:html5ever, "~> 0.9.0"},
      {:meeseeks_html5ever, "~> 0.13.1"},
      {:meeseeks, "~> 0.16.1"},
      {:fast_html, "~> 2.0.4"}
    ]
  end
end
