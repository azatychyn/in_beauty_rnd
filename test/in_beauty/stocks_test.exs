defmodule InBeauty.StocksTest do
  use InBeauty.DataCase

  alias InBeauty.Stocks

  describe "stocks" do
    alias InBeauty.Stocks.Stock

    import InBeauty.StocksFixtures

    @invalid_attrs %{image_path: nil, price: nil, quantity: nil, volume: nil, weight: nil}

    test "list_stocks/0 returns all stocks" do
      stock = stock_fixture()
      assert Stocks.list_stocks() == [stock]
    end

    test "get_stock!/1 returns the stock with given id" do
      stock = stock_fixture()
      assert Stocks.get_stock!(stock.id) == stock
    end

    test "create_stock/1 with valid data creates a stock" do
      valid_attrs = %{
        image_path: "some image_path",
        price: 42,
        quantity: 42,
        volume: 42,
        weight: 42
      }

      assert {:ok, %Stock{} = stock} = Stocks.create_stock(valid_attrs)
      assert stock.image_path == "some image_path"
      assert stock.price == 42
      assert stock.quantity == 42
      assert stock.volume == 42
      assert stock.weight == 42
    end

    test "create_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_stock(@invalid_attrs)
    end

    test "update_stock/2 with valid data updates the stock" do
      stock = stock_fixture()

      update_attrs = %{
        image_path: "some updated image_path",
        price: 43,
        quantity: 43,
        volume: 43,
        weight: 43
      }

      assert {:ok, %Stock{} = stock} = Stocks.update_stock(stock, update_attrs)
      assert stock.image_path == "some updated image_path"
      assert stock.price == 43
      assert stock.quantity == 43
      assert stock.volume == 43
      assert stock.weight == 43
    end

    test "update_stock/2 with invalid data returns error changeset" do
      stock = stock_fixture()
      assert {:error, %Ecto.Changeset{}} = Stocks.update_stock(stock, @invalid_attrs)
      assert stock == Stocks.get_stock!(stock.id)
    end

    test "delete_stock/1 deletes the stock" do
      stock = stock_fixture()
      assert {:ok, %Stock{}} = Stocks.delete_stock(stock)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_stock!(stock.id) end
    end

    test "change_stock/1 returns a stock changeset" do
      stock = stock_fixture()
      assert %Ecto.Changeset{} = Stocks.change_stock(stock)
    end
  end
end
