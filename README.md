[![CircleCI](https://circleci.com/gh/EssenceOfChaos/exmarket/tree/master.svg?style=svg)](https://circleci.com/gh/EssenceOfChaos/exmarket/tree/master)
![License](https://img.shields.io/github/license/essenceofchaos/exmarket.svg)

# Exmarket


An OTP application that provides real time **stock** & **crypto** data. This project is a _WIP_ under active development.

## Installation

Package is [available in Hex](https://hex.pm/packages/exmarket), and can be installed
by adding `exmarket` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exmarket, "~> 0.2.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/exmarket](https://hexdocs.pm/exmarket).

## Getting Started

After adding `{:exmarket, "~> 0.2.0"}` to your list of dependencies, access the API either by creating a unique alias or referring to `Exmarket` directly. For example:

```elixir
defmodule MyApp do
  alias Exmarket, as: Market

  def get_price(ticker) do
    Market.get_price(ticker)
  end

end
```

Calling `MyApp.get_price("aapl")` returns `"204.53"`.

Calling `MyApp.get_price("tsla")` returns `"258.66"`.

Previously retrieved stock prices are stored in GenServer state so calling MyApp.get_state() at this point would return `%{"aapl" => 204.53, "tsla" => 258.66}`.

The current state can be cleared by calling `MyApp.reset_state()`, which returns `:ok`.

## Getting prices for multiple stocks

Exmarket now supports batch quotes! Simply pass a list of strings for the stock prices you want. For example, `Exmarket.batch_quote(["aapl", "tsla", "fb", "msft"])` returns

```elixir
%{
  "aapl" => 207.16,
  "fb" => 182.58,
  "msft" => 125.01,
  "tsla" => 258.66}
```

---

If experience any bugs please file an [issue](https://github.com/EssenceOfChaos/exmarket/issues/new) so that I may address the concern. Or, if you would like to contribute please feel free to submit a pull request.
