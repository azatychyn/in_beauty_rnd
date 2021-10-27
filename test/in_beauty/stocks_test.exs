defmodule InBeauty.StocksTest do
  use InBeauty.DataCase
  import InBeautyWeb.Factory, only: [insert: 1, params_for: 1]

  alias InBeauty.Stocks
  alias InBeauty.Stocks.Stock

  @invalid_attrs %{image_path: nil, price: nil, quantity: nil, volume: nil, weight: nil}

  describe "stocks" do
    setup do
      %{stock: insert(:stock)}
    end

    test "list_stocks/0 returns all stocks", %{stock: stock} do
      assert Stocks.list_stocks() == [stock]
    end

    test "get_stock!/1 returns the stock with given id", %{stock: stock} do
      assert Stocks.get_stock!(stock.id) == stock
    end

    test "create_stock/1 with valid data creates a stock" do
      stock_params = params_for(:stock)
      assert {:ok, stock} = Stocks.create_stock(stock_params)
      assert stock.image_path == stock_params.image_path
      assert stock.price == stock_params.price
      assert stock.quantity == stock_params.quantity
      assert stock.volume == stock_params.volume
      assert stock.weight == stock_params.weight
    end

    test "create_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_stock(@invalid_attrs)
    end

    test "update_stock/2 with valid data updates the stock", %{stock: stock} do
      stock_params = params_for(:stock)

      assert {:ok, stock} = Stocks.update_stock(stock, stock_params)
      assert stock.image_path == stock_params.image_path
      assert stock.price == stock_params.price
      assert stock.quantity == stock_params.quantity
      assert stock.volume == stock_params.volume
      assert stock.weight == stock_params.weight
    end

    test "update_stock/2 with invalid data returns error changeset", %{stock: stock} do
      assert {:error, %Ecto.Changeset{}} = Stocks.update_stock(stock, @invalid_attrs)
      assert stock == Stocks.get_stock!(stock.id)
    end

    test "delete_stock/1 deletes the stock", %{stock: stock} do
      assert {:ok, %Stock{}} = Stocks.delete_stock(stock)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_stock!(stock.id) end
    end

    test "change_stock/1 returns a stock changeset", %{stock: stock} do
      assert %Ecto.Changeset{} = Stocks.change_stock(stock)
    end
  end
end
