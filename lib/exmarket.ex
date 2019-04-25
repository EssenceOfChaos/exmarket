defmodule Exmarket do
  alias Exmarket.Api.StockService
  alias Exmarket.Api.CryptoService

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
      %{"aapl" => 207.48, "fb" => 183.78, "mfst" => 0.065, "tsla" => 263.9}

  """

  defdelegate get_state(), to: StockService

  @doc """
    Resets the current state held in the GenServer back to an empty map
    ## Examples

      iex> Exmarket.reset_state()
      :ok
  """
  defdelegate reset_state(), to: StockService

  @doc """
  Takes a variable list of stock symbols and returns a map with the symbols and prices.

  ## Examples

    iex> Exmarket.batch_quote(["aapl", "tsla"])
    %{"aapl" => 207.48, "tsla" => 263.9}
  """
  def batch_quote([]), do: StockService.get_state()

  def batch_quote([head | tail]) when is_binary(head) do
    StockService.get_price(head)
    batch_quote(tail)
  end

  ###### Crypto Functions ######
  @doc """
  Returns the USD value of a crypto currency asset

  ## Examples

    iex> Exmarket.get_quote("btc")
    "5460.97"
  """
  defdelegate get_quote(pair), to: CryptoService
end
