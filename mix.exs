defmodule FlowDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :flow_demo,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :opentelemetry],
      mod: {FlowDemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:flow, "~> 1.0"},
      {:opentelemetry_api, "~> 0.3.0"},
      {:opentelemetry_zipkin, "~> 0.3.0"}
    ]
  end
end
