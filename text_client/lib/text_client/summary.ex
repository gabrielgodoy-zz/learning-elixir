defmodule TextClient.Summary do
  @moduledoc """
    
  """

  @doc """
    Função para printar feedback no terminal ao jogador
  """
  def display(game = %{ tally: tally }) do
    IO.puts([
      "\n",
      "Word so far: #{Enum.join(tally.letters, " ")}\n",
      "Guesses left: #{tally.turns_left}\n"
    ])
    game
  end
end
