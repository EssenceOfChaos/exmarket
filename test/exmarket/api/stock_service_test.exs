defmodule Exmarket.Api.StockServiceTest do
  @moduledoc """
  Test module for the StockService GenServer
  """
  use ExUnit.Case
  doctest Exmarket

  def reset_state(_context) do
    Exmarket.reset_state()
  end

  # one-arity function name
  setup :reset_state

  test "state begins as an empty map" do
    assert Exmarket.get_state() == %{}
  end

  test "call to get_price(stock) returns a value" do
    result = Exmarket.get_price("aapl")
    assert is_binary(result)
  end
end
