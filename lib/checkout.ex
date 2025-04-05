defmodule Checkout do
  @moduledoc """
  Handles checkout operations for products with various pricing rules,
  with a modular approach to pricing strategies.
  """

  alias PricingStrategy
  alias ProductConfig

  @doc """
  Calculates the total price for a list of products.
  Returns the total in pounds.
  """
  def checkout([]), do: 0

  def checkout(products) do
    products
    |> Enum.filter(&ProductConfig.exists?/1)
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
    case ProductConfig.get(product) do
      nil ->
        0

      config ->
        PricingStrategy.calculate(
          config.strategy,
          quantity,
          config.base_price,
          config.options
        )
    end
  end

  @doc false
  defp pennies_to_pounds(pennies) do
    pennies / 100
  end
end
