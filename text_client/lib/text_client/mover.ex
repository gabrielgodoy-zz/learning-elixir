defmodule TextClient.Mover do
  @moduledoc """
    Módulo responsável por interagir com o app Hangman
    e realizar uma jogada no jogo
  """

  alias TextClient.State

  @doc """
    
  """
  def make_move(game) do
    {game_service, tally} = Hangman.make_move(game.game_service, game.guess)
    %State{game | game_service: game_service, tally: tally}
  end
end
