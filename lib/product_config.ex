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
  @spec all() :: %{atom() => %{base_price: number(), strategy: atom(), options: keyword()}}
  def all do
    %{
      GR1: %{
        base_price: 311,
        strategy: :buy_one_get_one_free,
        options: []
      },
      SR1: %{
        base_price: 500,
        strategy: :bulk_discount,
        options: [min_quantity: 3, discounted_price: 450]
      },
      CF1: %{
        base_price: 1123,
        strategy: :bulk_discount,
        options: [min_quantity: 3, discount_percentage: 2 / 3]
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
