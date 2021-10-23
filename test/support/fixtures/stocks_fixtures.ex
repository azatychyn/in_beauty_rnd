defmodule InBeauty.StocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InBeauty.Stocks` context.
  """

  @doc """
  Generate a stock.
  """
  def stock_fixture(attrs \\ %{}) do
    {:ok, stock} =
      attrs
      |> Enum.into(%{
        image_path: "some image_path",
        price: 42,
        quantity: 42,
        volume: 42,
        weight: 42
      })
      |> InBeauty.Stocks.create_stock()

    stock
  end
end
