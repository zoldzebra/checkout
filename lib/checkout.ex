defmodule Checkout do
  @prices_in_pennies %{
    GR1: 311,
    SR1: 500,
    CF1: 1123
  }

  def checkout([]), do: 0

  def checkout(items) do
    items
    |> Enum.map(&@prices_in_pennies[&1])
    |> Enum.sum()
    |> pennies_to_pounds()
  end

  defp pennies_to_pounds(pennies) do
    pennies / 100
  end
end
