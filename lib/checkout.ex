defmodule Checkout do
  @moduledoc """
  Handles checkout operations for products with various pricing rules,
  with a modular approach to pricing strategies.
  """

  # Base product prices in pennies (to prevent floating point precision issues)
  @base_prices %{
    GR1: 311,
    SR1: 500,
    CF1: 1123
  }

  # Pricing strategy configuration
  @pricing_strategies %{
    GR1: {:buy_one_get_one_free, []},
    SR1: {:bulk_discount, [min_quantity: 3, discounted_price: 450]},
    CF1: {:bulk_discount, [min_quantity: 3, discount_percentage: 2 / 3]}
  }

  @doc """
  Calculates the total price for a list of products.
  Returns the total in pounds.
  """
  def checkout([]), do: 0

  def checkout(products) do
    products
    |> Enum.filter(&(&1 in Map.keys(@base_prices)))
    |> Enum.frequencies()
    |> calculate_total_price()
    |> pennies_to_pounds()
  end

  @doc false
  defp calculate_total_price(product_quantities) do
    Enum.reduce(product_quantities, 0, fn {product, quantity}, total ->
      total + calculate_product_price(product, quantity)
    end)
  end

  @doc false
  defp calculate_product_price(product, quantity) do
    base_price = @base_prices[product]

    case @pricing_strategies[product] do
      {strategy, options} ->
        apply_pricing_strategy(strategy, quantity, base_price, options)

      nil ->
        quantity * base_price
    end
  end

  # Pricing strategy implementations

  @doc false
  defp apply_pricing_strategy(:buy_one_get_one_free, quantity, base_price, _options) do
    charged_quantity = Float.ceil(quantity / 2)
    charged_quantity * base_price
  end

  @doc false
  defp apply_pricing_strategy(:bulk_discount, quantity, base_price, options) do
    min_quantity = Keyword.get(options, :min_quantity, 0)

    if quantity >= min_quantity do
      cond do
        discounted_price = Keyword.get(options, :discounted_price) ->
          quantity * discounted_price

        discount_percentage = Keyword.get(options, :discount_percentage) ->
          quantity * (base_price * discount_percentage)

        true ->
          quantity * base_price
      end
    else
      quantity * base_price
    end
  end

  @doc false
  defp apply_pricing_strategy(_unknown_strategy, quantity, base_price, _options) do
    quantity * base_price
  end

  @doc false
  defp pennies_to_pounds(pennies) do
    pennies / 100
  end
end
