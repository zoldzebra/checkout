defmodule PricingStrategyTest do
  use ExUnit.Case

  describe "calculate/4" do
    test "buy_one_get_one_free strategy" do
      assert PricingStrategy.calculate(:buy_one_get_one_free, 1, 100, []) == 100
      assert PricingStrategy.calculate(:buy_one_get_one_free, 2, 100, []) == 100
      assert PricingStrategy.calculate(:buy_one_get_one_free, 3, 100, []) == 200
      assert PricingStrategy.calculate(:buy_one_get_one_free, 4, 100, []) == 200
      assert PricingStrategy.calculate(:buy_one_get_one_free, 5, 100, []) == 300
    end

    test "bulk_discount strategy with discounted_price" do
      options = [min_quantity: 3, discounted_price: 80]

      assert PricingStrategy.calculate(:bulk_discount, 1, 100, options) == 100
      assert PricingStrategy.calculate(:bulk_discount, 2, 100, options) == 200
      assert PricingStrategy.calculate(:bulk_discount, 3, 100, options) == 240
      assert PricingStrategy.calculate(:bulk_discount, 4, 100, options) == 320
    end

    test "bulk_discount strategy with discount_percentage" do
      options = [min_quantity: 3, discount_percentage: 0.8]

      assert PricingStrategy.calculate(:bulk_discount, 1, 100, options) == 100
      assert PricingStrategy.calculate(:bulk_discount, 2, 100, options) == 200
      assert PricingStrategy.calculate(:bulk_discount, 3, 100, options) == 240
      assert PricingStrategy.calculate(:bulk_discount, 4, 100, options) == 320
    end

    test "bulk_discount strategy without discount options applies no discount" do
      options = [min_quantity: 3]

      assert PricingStrategy.calculate(:bulk_discount, 1, 100, options) == 100
      assert PricingStrategy.calculate(:bulk_discount, 2, 100, options) == 200
      assert PricingStrategy.calculate(:bulk_discount, 3, 100, options) == 300
      assert PricingStrategy.calculate(:bulk_discount, 4, 100, options) == 400
    end

    test "unknown strategy defaults to regular pricing" do
      assert PricingStrategy.calculate(:unknown, 1, 100, []) == 100
      assert PricingStrategy.calculate(:unknown, 2, 100, []) == 200
      assert PricingStrategy.calculate(:unknown, 3, 100, []) == 300
    end
  end
end
