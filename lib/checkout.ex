defmodule Checkout do
  @moduledoc """
  Handles checkout operations for products with various pricing rules,
  with a modular approach to pricing strategies.
  """

  alias PricingStrategy
  alias ProductConfig

  @doc """
  Calculates the total price for a list of products.
  Returns the total as a float with 2 decimal places.
  """
  def checkout([]), do: 0.00

  def checkout(products) do
    products
    |> Enum.filter(&ProductConfig.exists?/1)
    |> Enum.frequencies()
    |> calculate_total_price()
  end

  @doc false
  defp calculate_total_price(product_quantities) do
    Enum.reduce(product_quantities, Decimal.new(0), fn {product, quantity}, total ->
      product_price = calculate_product_price(product, quantity)
      Decimal.add(total, product_price)
    end)
    |> Decimal.round(2)
    |> Decimal.to_float()
  end

  @doc false
  defp calculate_product_price(product, quantity) do
    case ProductConfig.get(product) do
      nil ->
        Decimal.new(0)

      config ->
        PricingStrategy.calculate(
          config.strategy,
          quantity,
          config.base_price,
          config.options
        )
    end
  end
end
