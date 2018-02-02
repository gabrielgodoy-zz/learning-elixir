defmodule TextClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :text_client,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:hangman, path: "../hangman"},
      {
        :dialyxir,
        "~> 0.5",
        only: [:dev],
        runtime: false,
        paths: ["_"]
      }
    ]
  end
end
