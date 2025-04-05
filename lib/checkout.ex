defmodule Checkout do
  @moduledoc """
  Handles checkout operations for products with various pricing rules,
  with a modular approach to pricing strategies.
  """

  alias PricingStrategy

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
        PricingStrategy.calculate(strategy, quantity, base_price, options)

      nil ->
        PricingStrategy.calculate(:default, quantity, base_price, [])
    end
  end

  @doc false
  defp pennies_to_pounds(pennies) do
    pennies / 100
  end
end
