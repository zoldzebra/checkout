defmodule ProductConfig do
  @moduledoc """
  Provides product configuration including base prices and pricing strategies.

  This module centralizes all product-related configuration, making it easier
  to maintain and extend the product catalog.
  """

  @doc """
  Returns the configuration for all products.

  ## Returns
    A map of product codes to their configuration maps
  """
  @spec all() :: %{atom() => %{base_price: Decimal.t(), strategy: atom(), options: keyword()}}
  def all do
    %{
      GR1: %{
        base_price: Decimal.new("3.11"),
        strategy: :buy_one_get_one_free,
        options: []
      },
      SR1: %{
        base_price: Decimal.new("5.00"),
        strategy: :bulk_discount,
        options: [min_quantity: 3, discounted_price: Decimal.new("4.50")]
      },
      CF1: %{
        base_price: Decimal.new("11.23"),
        strategy: :bulk_discount,
        options: [min_quantity: 3, discount_percentage: Decimal.from_float(2 / 3)]
      }
    }
  end

  @spec get(atom()) :: map() | nil
  def get(product_code) do
    all()[product_code]
  end

  @spec exists?(atom()) :: boolean()
  def exists?(product_code) do
    product_code in Map.keys(all())
  end
end
