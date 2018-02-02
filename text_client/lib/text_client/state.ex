defmodule TextClient.State do
  @moduledoc """
    Definição da estrutura do estado do jogo 
  """

  defstruct(
    game_service: nil,
    tally: nil,
    guess: ''
  )
end
