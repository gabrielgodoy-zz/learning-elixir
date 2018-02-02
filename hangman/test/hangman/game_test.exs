defmodule Hangman.GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game should return correct structure" do
    assert %{
             letters: _,
             turns_left: 7,
             game_state: :initializing
           } = Game.new_game()
  end

  test "random_word should return only lowercase letters" do
    %{letters: letters} = Game.new_game()
    letters_downcased = letters
                        |> Enum.join()
                        |> String.downcase()

    assert letters_downcased == Enum.join(letters)
  end

  test "state isn't changed for both :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game()
             |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used

    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    game = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    game = Game.make_move(game, "b")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    game = Game.make_move(game, "l")
    assert game.game_state == :good_guess
    assert game.turns_left == 7

    game = Game.make_move(game, "e")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a guessed word is a won game with Enum.reduce" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    game = Game.new_game("wibble")

    # Enum.reduce([Coleção], [Estado Inicial], fn([Item Atual], [Acumulador]))
    Enum.reduce(
      moves,
      game,
      fn ({letter, state}, acc_game) -> # Function recebe atual e acumulador
        acc_game = Game.make_move(acc_game, letter)
        assert acc_game.game_state == state
        acc_game
        # O próprio estado acumulado do game é retornado
      end
    )
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "7 turns wrong is a lost game" do
    game = Game.new_game("w")

    game = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6

    game = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5

    game = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4

    game = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3

    game = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2

    game = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1

    game = Game.make_move(game, "g")
    assert game.game_state == :lost
  end

  test "should return invalid state if guess with multiple letters" do
    game = Game.new_game()

    game = Game.make_move(game, "abc")
    assert game.game_state == :invalid_guess
  end

  test "should return invalid state if guess with not a letter" do
    game = Game.new_game()

    game = Game.make_move(game, [1, 2, 3])
    assert game.game_state == :invalid_guess
  end
end
