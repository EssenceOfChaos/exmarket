defmodule Exmarket do
  alias Exmarket.Api.StockService

  @moduledoc """
  Documentation for Exmarket.
  """

  @doc """
  get_price(stock)

  ## Examples

      iex> Exmarket.get_price("aapl")
      "204.53"

  """
  defdelegate get_price(symbol), to: StockService

  @doc """
  get_state()

  ## Examples

      iex> Exmarket.get_state()
      %{"aapl" => 204.53}

  """
  defdelegate get_state(), to: StockService
end
