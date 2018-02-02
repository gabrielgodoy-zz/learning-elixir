defmodule Hangman do
  alias Hangman.Game

  defdelegate new_game(), to: Game
  defdelegate tally(game), to: Game

  @doc """
  Entregar o placar do jogo é responsabilidade da API,
  por isso é definido no nível da interface da API, 
  Essa entrega não é considerada implementação interna 
  """
  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    {game, tally(game)}
  end
end
