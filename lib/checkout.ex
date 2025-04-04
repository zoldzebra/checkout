defmodule Checkout do
  @moduledoc """
  Handles checkout operations for products with various pricing rules, with focus on flexibility of pricing rules.
  """

  # Base product prices in pennies (to prevent floating point precision issues)
  @base_prices %{
    GR1: 311,
    SR1: 500,
    CF1: 1123
  }

  # Products with buy-one-get-one-free discount
  @buy_one_get_one_free_products [:GR1]

  # Bulk pricing rules - {minimum_quantity, price_in_pennies}
  @bulk_pricing_rules %{
    SR1: {3, 450},
    CF1: {3, @base_prices[:CF1] * 2 / 3}
  }

  @doc """
  Calculates the total price for a list of products.
  Returns the total.
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
      total + calculate_total_price_for_product(product, quantity)
    end)
  end

  @doc false
  defp calculate_total_price_for_product(product, quantity) do
    base_price = @base_prices[product]

    cond do
      product in @buy_one_get_one_free_products ->
        charged_quantity = Float.ceil(quantity / 2)
        charged_quantity * base_price

      bulk_price = use_bulk_price?(product, quantity) ->
        quantity * bulk_price

      true ->
        quantity * base_price
    end
  end

  @doc false
  defp use_bulk_price?(product, quantity) do
    case @bulk_pricing_rules[product] do
      {min_quantity, price} when quantity >= min_quantity -> price
      _ -> false
    end
  end

  @doc false
  defp pennies_to_pounds(pennies) do
    pennies / 100
  end
end
