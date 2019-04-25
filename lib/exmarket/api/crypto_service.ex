defmodule Exmarket.Api.CryptoService do
  @moduledoc """
    Defines the Exmarket API for retreiving cryptocurrency data
  """
  use GenServer, restart: :transient
  require Logger

  @coin_api "?apikey=E47DBBF4-5FF7-4BCD-A221-DA2CA6A075EA"
  @coin_base "https://rest.coinapi.io/"
  @version "v1"
  @quote "/exchangerate/{BTC}/USD"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_quote(asset) do
    GenServer.call(__MODULE__, {:asset, asset})
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

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

  def handle_call({:asset, asset}, _from, state) do
    case quote_of(asset) do
      {:ok, price} ->
        new_state = update_state(state, asset, price)
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

  defp quote_of(asset) do
    uri = String.replace(@quote, "{BTC}", String.upcase(asset))
    # IO.inspect(@coin_base <> @version <> uri <> @coin_api)
    case HTTPoison.get(@coin_base <> @version <> uri <> @coin_api) do
      {:ok, %{status_code: 200, body: body}} -> process_response(Jason.decode!(body))
      # 404 Not Found Error
      {:ok, %{status_code: 404}} -> "Not found"
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect(reason)
    end
  end

  defp process_response(%{"rate" => rate}) when is_float(rate) do
    IO.inspect(rate)
    Logger.info("REACHED THIS FAR")

    {:ok, Float.round(rate, 2)}
  end

  defp update_state(old_state, pair, price) do
    case Map.has_key?(old_state, pair) do
      true ->
        Map.update!(old_state, pair, price)

      false ->
        Map.put_new(old_state, pair, price)
    end
  end
end
