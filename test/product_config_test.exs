defmodule ProductConfigTest do
  use ExUnit.Case

  require Decimal

  describe "all/0" do
    test "returns a map of product configurations" do
      products = ProductConfig.all()

      assert is_map(products)
      assert map_size(products) > 0

      Enum.each(products, fn {code, config} ->
        assert is_atom(code)
        assert is_map(config)
        assert Map.has_key?(config, :base_price)
        assert Map.has_key?(config, :strategy)
        assert Map.has_key?(config, :options)
        assert Decimal.is_decimal(config.base_price)
        assert is_atom(config.strategy)
        assert is_list(config.options)
      end)
    end

    test "includes expected product codes" do
      products = ProductConfig.all()

      assert Map.has_key?(products, :GR1)
      assert Map.has_key?(products, :SR1)
      assert Map.has_key?(products, :CF1)
    end

    test "products have correct configuration" do
      products = ProductConfig.all()

      assert Decimal.equal?(products[:GR1].base_price, Decimal.new("3.11"))
      assert products[:GR1].strategy == :buy_one_get_one_free
      assert products[:GR1].options == []

      assert Decimal.equal?(products[:SR1].base_price, Decimal.new("5.00"))
      assert products[:SR1].strategy == :bulk_discount
      assert Keyword.get(products[:SR1].options, :min_quantity) == 3

      assert Decimal.equal?(
               Keyword.get(products[:SR1].options, :discounted_price),
               Decimal.new("4.50")
             )

      assert Decimal.equal?(products[:CF1].base_price, Decimal.new("11.23"))
      assert products[:CF1].strategy == :bulk_discount
      assert Keyword.get(products[:CF1].options, :min_quantity) == 3

      assert Decimal.equal?(
               Keyword.get(products[:CF1].options, :discount_percentage),
               Decimal.from_float(2 / 3)
             )
    end
  end

  describe "get/1" do
    test "returns configuration for existing product" do
      config = ProductConfig.get(:GR1)

      assert is_map(config)
      assert Decimal.equal?(config.base_price, Decimal.new("3.11"))
      assert config.strategy == :buy_one_get_one_free
    end

    test "returns nil for non-existent product" do
      assert ProductConfig.get(:NONEXISTENT) == nil
    end
  end

  describe "exists?/1" do
    test "returns true for existing products" do
      assert ProductConfig.exists?(:GR1)
      assert ProductConfig.exists?(:SR1)
      assert ProductConfig.exists?(:CF1)
    end

    test "returns false for non-existent products" do
      assert ProductConfig.exists?(:NONEXISTENT) == false
      assert ProductConfig.exists?(:ABC) == false
    end
  end
end
