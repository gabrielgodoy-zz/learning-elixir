defmodule Dictionary do
  @moduledoc """
  Documentation for Dictionary.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dictionary.hello
      :world

  """

  def random_word do
    word_list()
    |> Enum.random()
  end

  def word_list do
    "../assets/words.txt"
    |> Path.expand(__DIR__) # __DIR__ is the source directory of the module
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def get_equal_chars do
    sentence = "had we but world enough, and time"
    comparison_sentence = "had we but bacon enough, and treacle"
    String.myers_difference(sentence, comparison_sentence)
  end
end
