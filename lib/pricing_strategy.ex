defmodule PricingStrategy do
  @moduledoc """
  Provides various pricing strategies for the checkout system.

  Each strategy implements a specific pricing rule that can be applied to products.
  Strategies are designed to be testable and composable.
  """

  @doc """
  Calculates the price based on the given strategy, quantity, and base price.

  ## Parameters
    * `strategy` - The pricing strategy to apply
    * `quantity` - The number of items
    * `base_price` - The regular price per item
    * `options` - Strategy-specific configuration options

  ## Returns
    The total price as a Decimal rounded to 2 decimal places
  """
  @spec calculate(:buy_one_get_one_free, non_neg_integer(), Decimal.t(), keyword()) :: Decimal.t()
  def calculate(strategy, quantity, base_price, options \\ [])

  def calculate(:buy_one_get_one_free, quantity, base_price, _options) do
    charged_quantity = Decimal.from_float(Float.ceil(quantity / 2))

    base_price
    |> Decimal.mult(charged_quantity)
    |> round_decimal()
  end

  @spec calculate(:bulk_discount, non_neg_integer(), Decimal.t(), keyword()) :: Decimal.t()
  def calculate(:bulk_discount, quantity, base_price, options) do
    min_quantity = Keyword.get(options, :min_quantity, 0)
    quantity_decimal = Decimal.new(quantity)

    if quantity >= min_quantity do
      cond do
        discounted_price = Keyword.get(options, :discounted_price) ->
          discounted_price
          |> Decimal.mult(quantity_decimal)
          |> round_decimal()

        discount_percentage = Keyword.get(options, :discount_percentage) ->
          base_price
          |> Decimal.mult(discount_percentage)
          |> Decimal.mult(quantity_decimal)
          |> round_decimal()

        true ->
          base_price
          |> Decimal.mult(quantity_decimal)
          |> round_decimal()
      end
    else
      base_price
      |> Decimal.mult(quantity_decimal)
      |> round_decimal()
    end
  end

  @spec calculate(atom(), non_neg_integer(), Decimal.t(), keyword()) :: Decimal.t()
  def calculate(_strategy, quantity, base_price, _options) do
    base_price
    |> Decimal.mult(Decimal.new(quantity))
    |> round_decimal()
  end

  defp round_decimal(decimal) do
    Decimal.round(decimal, 2)
  end
end
