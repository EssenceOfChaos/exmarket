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
    {:exmarket, "~> 0.1.1"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/exmarket](https://hexdocs.pm/exmarket).

After adding `{:exmarket, "~> 0.1.0"}` to your list of dependencies, access the API either by creating a unique alias or referring to `Exmarket` directly. For example:

```elixir
defmodule MyApp do
  alias Exmarket, as: Market

  def get_price(ticker) do
    Market.get_price(ticker)
  end

end
```

Calling `MyApp.get_price("aapl")` returns `"204.53"`.
