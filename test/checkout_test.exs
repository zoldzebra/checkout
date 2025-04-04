defmodule CheckoutTest do
  use ExUnit.Case

  describe "checkout" do
    test "returns 0 for empty basket" do
      assert Checkout.checkout([]) == 0
    end

    test "returns 3.11 for one GR1" do
      assert Checkout.checkout([:GR1]) == 3.11
    end

    test "returns 5.00 for one SR1" do
      assert Checkout.checkout([:SR1]) == 5.00
    end

    test "returns 11.23 for one CF1" do
      assert Checkout.checkout([:CF1]) == 11.23
    end

    test "returns 19.34 for one GR1, one SR1 and one CF1" do
      assert Checkout.checkout([:GR1, :SR1, :CF1]) == 19.34
    end

    test "applies buy-1-get-1-free pricing rule on GR1" do
      assert Checkout.checkout([:GR1, :GR1]) == 3.11
      assert Checkout.checkout([:GR1, :GR1, :GR1]) == 6.22
      assert Checkout.checkout([:GR1, :GR1, :GR1, :GR1]) == 6.22
      assert Checkout.checkout([:GR1, :GR1, :GR1, :GR1, :GR1]) == 9.33
      assert Checkout.checkout([:GR1, :GR1, :GR1, :GR1, :GR1, :GR1]) == 9.33
    end
  end
end
