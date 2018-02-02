defmodule TextClient.Summary do
  @moduledoc """
    Exibe o status atual do jogo no terminal 
  """

  @doc """
    Função para printar feedback no terminal ao jogador
  """
  def display(game = %{ game_service: game_service, tally: tally }) do
    IO.puts([
      "\n",
      "Used letters #{Enum.join(game_service.used, " ")}\n",
      "Word so far: #{Enum.join(tally.letters, " ")}\n",
      "Guesses left: #{tally.turns_left}\n"
    ])
    game
  end
end
