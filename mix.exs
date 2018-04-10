defmodule ActiveJorb.MixProject do
  use Mix.Project

  def project do
    [
      app: :active_jorb,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/jherdman/active_jorb/",
      docs: [
        extras: [
          "README.md",
          "LICENSE.md"
        ],
        main: "README"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :sidewalk]
    ]
  end

  defp description do
    """
    A library to enqueue jobs with your Active Job job processor. You may want
    this when strangling your Rails project.
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.9.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.18.3", only: :dev, runtime: false},
      {:redix, "~> 0.6", optional: true},

      # BELOW: USED BY QUEUE ADAPTERS

      {:sidewalk, ">= 0.3.4 and < 1.0.0", optional: true}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/PrecisionNutrition/active_jorb"
      },
      maintainers: ["James Herdman"]
    ]
  end
end
