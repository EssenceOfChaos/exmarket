defmodule Exmarket do
  alias Exmarket.Api.StockService

  @moduledoc """
  Documentation for Exmarket.
  """

  @doc """
  Takes the stock symbol (ticker) as input and returns the real-time value of the stock.

  ## Examples

      iex> Exmarket.get_price("aapl")
      "204.53"

  """

  defdelegate get_price(symbol), to: StockService

  @doc """
  Returns the current state of the GenServer. Previous calls to `get_price(stock)` are cached and returned as a map.

  ## Examples

      iex> Exmarket.get_state()
      %{}

  """

  defdelegate get_state(), to: StockService

  @doc """
    Resets the current state held in the GenServer back to an empty map
    ## Examples

      iex> Exmarket.reset_state()
      :ok
  """
  defdelegate reset_state(), to: StockService
end
