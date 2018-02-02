defmodule TextClient do
  @moduledoc """
    
  """

  defdelegate start(), to: TextClient.Interact
end
