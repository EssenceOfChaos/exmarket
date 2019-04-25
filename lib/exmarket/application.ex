defmodule Exmarket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Exmarket.Api.StockService
  alias Exmarket.Api.CryptoService

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Exmarket.Worker.start_link(arg)
      {StockService, %{}},
      {CryptoService, %{}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exmarket.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
