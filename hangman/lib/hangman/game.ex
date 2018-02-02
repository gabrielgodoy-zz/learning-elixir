defmodule Hangman.Game do
  @moduledoc """
  Implementação interna do jogo da Forca
  Sistemas internos não interagem diretamente com esse módulo
  """

  @doc """
  # Parâmetros
  
  - turns_left: Jogadas que faltam pro usuário
  - game_state: Representa o estado atual do jogo
  - letters: Lista com letras que o usuário tentou no jogo
  - used: MapSet com letras que já foram usadas
  """
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @doc """
  Inicia um novo jogo, criando um novo Struct contendo o estado do jogo

  Roda caso:
  - Uma palavra especifica é passada para new_game

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - _guess: Letra que jogador tenta no jogo
  """
  def new_game(word) do
    %Hangman.Game{
      letters: word
               |> String.codepoints()
    }
  end

  @doc """
  Inicia um novo jogo, criando um novo Struct contendo o estado do jogo
  """
  def new_game() do
    new_game(Dictionary.random_word())
  end

  @doc """
  Roda quando usuário faz uma jogada no jogo, quando tenta uma letra

  Roda caso:
  - O estado do jogo estiver `:won` ou `:lost`

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - _guess: Letra que jogador tenta no jogo
  """
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game # tally é o placar do jogo
  end

  @doc """
  Roda quando usuário faz uma jogada no jogo, quando tenta uma letra

  Roda caso:
  - Em qualquer hora do jogo que não forem estados `:won` ou `:lost`

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - _guess: Letra que jogador tenta no jogo
  """
  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess), is_valid_guess?(guess))
  end

  @doc """
  Representa detalhes sobre o placar do jogo (tally) 
  ao aplicativo externo que consome esse Jogo da Forca
  
  Só se deve revelar o que o aplicativo externo pode consumir,
  deve-se esconder a palavra a ser descoberta por exemplo

  ## Parâmetros
  - _game: Struct que armazena detalhes do jogo
  """
  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters
              |> reveal_guessed(game.used)
    }
  end

  # PRIVATE FUNCTIONS BELOW

  @doc """
  Define se a jogada no jogo vai ser aceita

  Roda caso:
  - A letra já foi tentada no jogo

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - guess: Letra que jogador está tentando
  - _already_guessed: Boolean que define se letra já foi tentada no jogo
  
  Com underline "_already_guessed" é ignorado, só o seu valor precisa ser "true". 
  O termo "_already_guessed" em si, vai servir para o true não ficar sem identificação
  """
  defp accept_move(game, _guess, _already_guessed = true, _is_valid_guess = true) do
    Map.put(game, :game_state, :already_used)
  end

  @doc """
  Define se a jogada no jogo vai ser aceita
  
  Roda caso:
  - A letra nunca foi tentada no jogo
  - Se a tentativa é válida (uma letra minúscula foi a tentativa)

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - guess: Letra que jogador está tentando
  - _already_guessed: Boolean que define se letra já foi tentada no jogo
  """
  defp accept_move(game, guess, _already_guessed, _is_valid_guess = true) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  @doc """
  Define se a jogada no jogo vai ser aceita
  
  Roda caso:
  - A letra nunca foi tentada no jogo
  
  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - guess: Letra que jogador está tentando
  - _already_guessed: Boolean que define se letra já foi tentada no jogo
  """
  defp accept_move(game, guess, _already_guessed, _is_invalid_guess) do
    Map.put(game, :game_state, :invalid_guess)
  end

  @doc """
  Checa se a letra que o jogador tentou foi bem sucedida, se acertou uma letra

  Roda caso:
  - A letra que o usuário tentou está presente na palavra secreta  

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - _good_guess: Checa se a letra pertence a palavra secreta
  """
  defp score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters) # Converte as letras da palavra em um MapSet

                # True quando as letras da palavra secreta 
                # forem um subset das letras que já foram tentadas
                |> MapSet.subset?(game.used)   # Se for true, a palavra foi descoberta
                |> maybe_won()

    Map.put(game, :game_state, new_state)
  end

  @doc """
  Checa se a letra que o jogador tentou foi bem sucedida, se acertou uma letra

  Roda caso: 
  - A letra que o usuário tentou não está presente na palavra secreta 
  - Se não existem mais jogadas restantes (Se turns_left == 1, vai ser zero no próximo)

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - _not_good_guess: Checa se a letra pertence a palavra secreta
  """
  defp score_guess(game = %{turns_left: 1}, _not_good_guess) do
    Map.put(game, :game_state, :lost)
  end

  @doc """
  Checa se a letra que o jogador tentou foi bem sucedida, se acertou uma letra

  Roda caso: 
  - A letra que o usuário tentou não está presente na palavra secreta 
  - Se ainda existem mais jogadas restantes

  ## Parâmetros
  - game: Struct que armazena detalhes do jogo
  - _not_good_guess: Checa se a letra pertence a palavra secreta
  """
  defp score_guess(game = %{turns_left: turns_left}, _not_good_guess) do
    # Usando o caracter "|" para atualizar mais de uma propriedade 
    %{
      game |
      game_state: :bad_guess,
      turns_left: turns_left - 1
    }
  end

  @doc """
  Se decide quais letras devem ser reveladas ao mundo externo

  Map em cada letra da palavra secreta, se uma letra estiver 
  na lista de letras que já foram tentadas pelo jogador ("used" letters), ela entra

  ## Parâmetros
  - letters: Lista com letras da palavra secreta
  - used: Lista com letras que já foram tentadas
  """
  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  @doc """
  Se a letra estiver na palavra, entrega a letra, senão entrega "_"
  """
  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _not_in_word), do: "_"

  @doc """
  Função define se jogador ganhou porque terminou o jogo, ou se teve um acerto somente
  """
  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  @doc """
  
  """
  defp is_valid_guess?(guess) when is_binary(guess) do
    guess_downcased = guess
                      |> String.downcase()

    guess_downcased == guess && String.length(guess) == 1
  end

  @doc """
  
  """
  defp is_valid_guess?(guess) do
    false
  end
end
