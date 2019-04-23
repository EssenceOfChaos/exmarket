defmodule Exmarket.Api.StockService do
  @moduledoc """
    Defines the Exmarket API for retreiving stock data
  """
  use GenServer, restart: :transient
  # @url "https://api.iextrading.com/1.0/stock/{SYMBOL}/price"
  # @full_url "https://cloud.iexapis.com/beta/stock/aapl/price?token=pk_40c6c71966a445cca7038a5445fd54a0"
  @base "https://cloud.iexapis.com/"
  @version "beta"
  # @base_url "https://cloud.iexapis.com/stable/tops?token=pk_40c6c71966a445cca7038a5445fd54a0&symbols={SYM}"
  @sector_path "stock/market/sector-performance"
  @price "/stock/{symbol}/price"
  @pk "?token=pk_40c6c71966a445cca7038a5445fd54a0"
  ## ------------------------------------------------- ##
  ##                   Client API                      ##
  ## ------------------------------------------------- ##
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
    Gets the price of the stock passed as an arguement. Returns a String

    ## Examples

    iex> StockService.get_price(pid, "aapl")
    "142.19"

  """
  def get_price(stock) do
    GenServer.call(__MODULE__, {:stock, stock})
  end

  def batch_quote(stocks) do
    stocks
    |> Enum.each(fn stock ->
      GenServer.call(__MODULE__, {:stock, stock})
    end)

    GenServer.call(__MODULE__, :get_state)
  end

  def sectorPerformance() do
    case HTTPoison.get(@base <> @version <> @sector_path <> @pk) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  @doc """
    Gets the current state of the StockService. Returns a Map

    ## Examples

    iex> StockService.get_state(pid)
    %{"aapl" => 148.26}

  """
  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  @doc """
    Resets the state of the StockService to an empty map. Returns :ok

    ## Examples

    iex> StockService.get_state(pid)
    %{"aapl" => 148.26}

  """
  def reset_state() do
    GenServer.cast(__MODULE__, :reset_state)
  end

  def stop() do
    GenServer.cast(__MODULE__, :stop)
  end

  ## ------------------------------------------------- ##
  ##                   Server API                      ##
  ## ------------------------------------------------- ##

  def init(opts \\ %{}) do
    {:ok, opts}
  end

  def handle_call({:stock, stock}, _from, state) do
    case price_of(stock) do
      {:ok, price} ->
        new_state = update_state(state, stock, price)
        {:reply, "#{price}", new_state}

      _ ->
        {:reply, :error, state}
    end
  end

  def handle_call(:get_state, _from, state) do
    # action, response, new state(no change)
    {:reply, state, state}
  end

  def handle_cast(:reset_state, _state) do
    # note: no response
    # action, current state(set to empty map)
    {:noreply, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def terminate(reason, stats) do
    # We could write to a file, database etc
    IO.puts("server terminated because of #{inspect(reason)}")
    inspect(stats)
    :ok
  end

  def handle_info(msg, state) do
    IO.puts("received #{inspect(msg)}")
    {:noreply, state}
  end

  ## ------------------------------------------------- ##
  ##                   Helper Functions                ##
  ## ------------------------------------------------- ##

  defp price_of(stock) do
    uri = String.replace(@price, "{symbol}", stock)

    case HTTPoison.get(@base <> @version <> uri <> @pk) do
      {:ok, %{status_code: 200, body: body}} -> Jason.decode(body)
      # 404 Not Found Error
      {:ok, %{status_code: 404}} -> "Not found"
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect(reason)
    end
  end

  defp update_state(old_state, stock, price) do
    case Map.has_key?(old_state, stock) do
      true ->
        Map.update!(old_state, stock, price)

      false ->
        Map.put_new(old_state, stock, price)
    end
  end

  defp process_response_body(body) do
    body
    |> Jason.decode!()
  end
end
