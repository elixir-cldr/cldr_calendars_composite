defmodule Cldr.Calendars.Composite.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :cldr_calendars_composite,
      version: @version,
      elixir: "~> 1.8",
      name: "Cldr Composite Calendars",
      source_url: "https://github.com/elixir-cldr/cldr_calendars_composite",
      docs: docs(),
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w()a
      ]
    ]
  end

  defp description do
    """
    Composite calendars (composing non-overlapping calendars into one)
    using the Common Locale Data Repository (CLDR).
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_cldr_calendars, "~> 1.17"},
      {:jason, "~> 1.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false, optional: true},
      {:ex_doc, "~> 0.21", only: [:release, :dev]},
    ]
  end

  defp package do
    [
      maintainers: ["Kip Cole"],
      licenses: ["Apache 2.0"],
      links: links(),
      files: [
        "lib",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*"
      ]
    ]
  end

  def links do
    %{
      "GitHub" => "https://github.com/elixir-cldr/cldr_calendars_composite",
      "Changelog" =>
        "https://github.com/elixir-cldr/cldr_calendars_composite/blob/v#{@version}/CHANGELOG.md",
      "Readme" =>
        "https://github.com/elixir-cldr/cldr_calendars_composite/blob/v#{@version}/README.md"
    }
  end

  def docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: ["README.md", "CHANGELOG.md", "LICENSE.md"],
      logo: "logo.png",
      skip_undefined_reference_warnings_on: ["changelog", "readme", "CHANGELOG.md"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "mix", "test"]
  defp elixirc_paths(:dev), do: ["lib", "mix"]
  defp elixirc_paths(:docs), do: ["lib", "mix"]
  defp elixirc_paths(_), do: ["lib"]
end
