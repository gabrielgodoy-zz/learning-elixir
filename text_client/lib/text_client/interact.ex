defmodule TextClient.Interact do
  @moduledoc """
    Módulo que contém: 
    - Start principal da aplicação
    - Setup_state para ficar atualizando o estado
    - O player que se auto-chama
  """

  alias TextClient.{Player, State}

  @doc """
    Inicia um jogo
  """
  def start() do
    Hangman.new_game()
    |> setup_state()
    |> Player.play()
  end

  @doc """
    Recebe o new_game, o struct game que ele recebe
  """
  defp setup_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game),
    }
  end

  @doc """
    Função que muda o estado, quando usuário faz uma jogada
  """
  def play(state) do
    play(state)
  end
end
