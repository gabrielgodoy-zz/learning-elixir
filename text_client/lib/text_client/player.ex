defmodule TextClient.Player do
  @moduledoc """
    
  """

  alias TextClient.{Mover, Prompter, State, Summary}

  @doc """
    Possíveis estados retornados do placar do app Hangman
    # :won, :lost, :good_guess, :bad_guess, :already_used, :initializing

    Roda caso:
  - Estado do jogo é :won
  """
  def play(%State{tally: %{game_state: :won}}) do
    exit_with_message("You WON!")
  end

  @doc """
    Roda caso:
  - Estado do jogo é :lost
  """
  def play(%State{tally: %{game_state: :lost}}) do
    exit_with_message("Sorry, you lost")
  end

  @doc """
    Roda caso:
  - Estado do jogo é :good_guess
  """
  def play(game = %State{tally: %{game_state: :good_guess}}) do
    continue_with_message(game, "Good guess!")
  end

  @doc """
    Roda caso:
  - Estado do jogo é :bad_guess
  """
  def play(game = %State{tally: %{game_state: :bad_guess}}) do
    continue_with_message(game, "Sorry, that isn't in the word")
  end

  @doc """
    Roda caso:
  - Estado do jogo é :already_used
  """
  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "You've already used that letter")
  end

  @doc """
    Roda caso:
  - Estado do jogo é outro
  """
  def play(game) do
    continue(game)
  end

  def continue_with_message(game, message) do
    IO.puts(message)
    continue(game)
  end

  @doc """
    Função que faz jogador continuar
  """
  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
