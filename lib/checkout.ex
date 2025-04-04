defmodule Checkout do
  @flat_prices_in_pennies %{
    GR1: 311,
    SR1: 500,
    CF1: 1123
  }
  @buy_1_get_1_free_products [:GR1]
  @bulk_pricing_rules %{
    :SR1 => {3, 450},
    :CF1 => {3, @flat_prices_in_pennies[:CF1] * 2 / 3}
  }

  def checkout([]), do: 0

  def checkout(products) do
    products
    |> Enum.frequencies()
    |> Enum.map(fn {product, quantity} ->
      calculate_product_price(product, quantity)
    end)
    |> Enum.sum()
    |> pennies_to_pounds()
  end

  defp calculate_product_price(product, quantity) do
    price = @flat_prices_in_pennies[product]

    if product in @buy_1_get_1_free_products do
      quantity_to_charge = Float.ceil(quantity / 2)
      quantity_to_charge * price
    else
      price = maybe_bulk_price?(product, quantity)
      quantity * price
    end
  end

  defp maybe_bulk_price?(product, quantity) do
    case @bulk_pricing_rules[product] do
      {min_quantity, price} when quantity >= min_quantity ->
        price

      _ ->
        @flat_prices_in_pennies[product]
    end
  end

  defp pennies_to_pounds(pennies) do
    pennies / 100
  end
end
