defmodule PricingStrategyTest do
  use ExUnit.Case

  describe "calculate/4" do
    test "buy_one_get_one_free strategy" do
      base_price = Decimal.new("100")

      assert PricingStrategy.calculate(:buy_one_get_one_free, 1, base_price, []) ==
               Decimal.new("100.00")

      assert PricingStrategy.calculate(:buy_one_get_one_free, 2, base_price, []) ==
               Decimal.new("100.00")

      assert PricingStrategy.calculate(:buy_one_get_one_free, 3, base_price, []) ==
               Decimal.new("200.00")

      assert PricingStrategy.calculate(:buy_one_get_one_free, 4, base_price, []) ==
               Decimal.new("200.00")

      assert PricingStrategy.calculate(:buy_one_get_one_free, 5, base_price, []) ==
               Decimal.new("300.00")
    end

    test "bulk_discount strategy with discounted_price" do
      base_price = Decimal.new("100")
      options = [min_quantity: 3, discounted_price: Decimal.new("80")]

      assert PricingStrategy.calculate(:bulk_discount, 1, base_price, options) ==
               Decimal.new("100.00")

      assert PricingStrategy.calculate(:bulk_discount, 2, base_price, options) ==
               Decimal.new("200.00")

      assert PricingStrategy.calculate(:bulk_discount, 3, base_price, options) ==
               Decimal.new("240.00")

      assert PricingStrategy.calculate(:bulk_discount, 4, base_price, options) ==
               Decimal.new("320.00")
    end

    test "bulk_discount strategy with discount_percentage" do
      base_price = Decimal.new("100")
      options = [min_quantity: 3, discount_percentage: Decimal.from_float(0.8)]

      assert PricingStrategy.calculate(:bulk_discount, 1, base_price, options) ==
               Decimal.new("100.00")

      assert PricingStrategy.calculate(:bulk_discount, 2, base_price, options) ==
               Decimal.new("200.00")

      assert PricingStrategy.calculate(:bulk_discount, 3, base_price, options) ==
               Decimal.new("240.00")

      assert PricingStrategy.calculate(:bulk_discount, 4, base_price, options) ==
               Decimal.new("320.00")
    end

    test "bulk_discount strategy with discount_percentage that is not a float" do
      base_price = Decimal.new("100")
      options = [min_quantity: 3, discount_percentage: Decimal.from_float(2 / 3)]

      assert PricingStrategy.calculate(:bulk_discount, 1, base_price, options) ==
               Decimal.new("100.00")

      assert PricingStrategy.calculate(:bulk_discount, 2, base_price, options) ==
               Decimal.new("200.00")

      assert PricingStrategy.calculate(:bulk_discount, 3, base_price, options) ==
               Decimal.new("200.00")

      assert PricingStrategy.calculate(:bulk_discount, 4, base_price, options) ==
               Decimal.new("266.67")
    end

    test "bulk_discount strategy without discount options applies no discount" do
      base_price = Decimal.new("100")
      options = [min_quantity: 3]

      assert PricingStrategy.calculate(:bulk_discount, 1, base_price, options) ==
               Decimal.new("100.00")

      assert PricingStrategy.calculate(:bulk_discount, 2, base_price, options) ==
               Decimal.new("200.00")

      assert PricingStrategy.calculate(:bulk_discount, 3, base_price, options) ==
               Decimal.new("300.00")

      assert PricingStrategy.calculate(:bulk_discount, 4, base_price, options) ==
               Decimal.new("400.00")
    end

    test "unknown strategy defaults to regular pricing" do
      base_price = Decimal.new("100")
      assert PricingStrategy.calculate(:unknown, 1, base_price, []) == Decimal.new("100.00")
      assert PricingStrategy.calculate(:unknown, 2, base_price, []) == Decimal.new("200.00")
      assert PricingStrategy.calculate(:unknown, 3, base_price, []) == Decimal.new("300.00")
    end
  end
end
