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
    * `base_price` - The regular price per item in pennies
    * `options` - Strategy-specific configuration options

  ## Returns
    The total price in pennies
  """
  @spec calculate(:buy_one_get_one_free, non_neg_integer(), number(), keyword()) :: number()
  def calculate(strategy, quantity, base_price, options \\ [])

  def calculate(:buy_one_get_one_free, quantity, base_price, _options) do
    charged_quantity = Float.ceil(quantity / 2)
    charged_quantity * base_price
  end

  @spec calculate(:bulk_discount, non_neg_integer(), number(), keyword()) :: number()
  def calculate(:bulk_discount, quantity, base_price, options) do
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

  @spec calculate(atom(), non_neg_integer(), number(), keyword()) :: number()
  def calculate(_strategy, quantity, base_price, _options) do
    quantity * base_price
  end
end
