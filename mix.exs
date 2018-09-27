defmodule Mustachex.Mixfile do
  use Mix.Project

  def project do
    [app: :mustachex,
     version: "0.0.2",
     elixir: "~> 1.0",
     deps: deps(),
     description: description(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end

  defp description do
    "Mustache for Elixir"
  end

  def package do
    [ contributors: ["jui"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jui/mustachex"}]
  end
end
