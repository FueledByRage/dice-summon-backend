defmodule DiceSummon.MixProject do
  use Mix.Project

  def project do
    [
      app: :dice_summon,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {DiceSummon.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.6"},
      {:mongodb_driver, "~> 1.0"},
      {:jason, "~> 1.4"},
      {:cachex, "~> 3.6"},
      {:bcrypt_elixir, "~> 3.0"}
    ]
  end
end
