defmodule InBeauty.StocksTest do
  use InBeauty.DataCase

  import InBeautyWeb.Factory,
    only: [build: 1, build: 2, insert: 1, insert: 2, params_for: 1, params_for: 2]

  alias InBeauty.Stocks
  alias InBeauty.Stocks.{ReservedStock, Stock}

  @invalid_attrs %{image_path: nil, price: nil, quantity: nil, volume: nil, weight: nil}

  describe "stocks" do
    setup do
      %{stock: insert(:stock, perfume: build(:perfume, stocks: []))}
    end

    test "list_stocks/0 returns all stocks", %{stock: %{id: id}} do
      assert [%{id: ^id}] = Stocks.list_stocks()
    end

    test "get_stock!/1 returns the stock with given id", %{stock: stock} do
      fetched_stock = Stocks.get_stock!(stock.id)
      assert fetched_stock.image_path == stock.image_path
      assert fetched_stock.price == stock.price
      assert fetched_stock.quantity == stock.quantity
      assert fetched_stock.volume == stock.volume
      assert fetched_stock.weight == stock.weight
    end

    test "create_stock/1 with valid data creates a stock" do
      stock_params = params_for(:stock, perfume: insert(:perfume))
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
      fetched_stock = Stocks.get_stock!(stock.id)
      assert fetched_stock.image_path == stock.image_path
      assert fetched_stock.price == stock.price
      assert fetched_stock.quantity == stock.quantity
      assert fetched_stock.volume == stock.volume
      assert fetched_stock.weight == stock.weight
    end

    test "delete_stock/1 deletes the stock", %{stock: stock} do
      assert {:ok, %Stock{}} = Stocks.delete_stock(stock)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_stock!(stock.id) end
    end

    test "change_stock/1 returns a stock changeset", %{stock: stock} do
      assert %Ecto.Changeset{} = Stocks.change_stock(stock)
    end
  end

  describe "reserved_stocks" do
    setup do
      %{reserved_stock: create_reserved_stock_with_assoc()}
    end

    test "list_reserved_stocks/0 returns all reserved_stocks", %{reserved_stock: %{id: id}} do
      assert [%{id: ^id}] = Stocks.list_reserved_stocks()
    end

    test "get_reserved_stock!/1 returns the reserved_stock with given id", %{
      reserved_stock: reserved_stock
    } do
      fetchd_reserved_stock = Stocks.get_reserved_stock!(reserved_stock.id)
      assert fetchd_reserved_stock.quantity == reserved_stock.quantity
      assert fetchd_reserved_stock.volume == reserved_stock.volume
    end

    test "create_reserved_stock/1 with valid data creates a reserved_stock", %{
      reserved_stock: reserved_stock
    } do
      reserved_stock_params =
        params_for(:reserved_stock,
          stock_id: reserved_stock.stock.id,
          order_id: reserved_stock.order_id
        )

      assert {:ok, reserved_stock} = Stocks.create_reserved_stock(reserved_stock_params)
      assert reserved_stock.quantity == reserved_stock_params.quantity
      assert reserved_stock.volume == reserved_stock_params.volume
    end

    test "create_reserved_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_reserved_stock(@invalid_attrs)
    end

    test "update_reserved_stock/2 with valid data updates the reserved_stock", %{
      reserved_stock: reserved_stock
    } do
      reserved_stock_params = params_for(:reserved_stock, stock_id: reserved_stock.stock.id)

      assert {:ok, reserved_stock} =
               Stocks.update_reserved_stock(reserved_stock, reserved_stock_params)

      assert reserved_stock.quantity == reserved_stock_params.quantity
      assert reserved_stock.volume == reserved_stock_params.volume
    end

    test "update_reserved_stock/2 with invalid data returns error changeset", %{
      reserved_stock: reserved_stock
    } do
      assert {:error, %Ecto.Changeset{}} =
               Stocks.update_reserved_stock(reserved_stock, @invalid_attrs)

      fetched_reserved_stock = Stocks.get_reserved_stock!(reserved_stock.id)
      assert reserved_stock.quantity == fetched_reserved_stock.quantity
      assert reserved_stock.volume == fetched_reserved_stock.volume
    end

    test "delete_reserved_stock/1 deletes the reserved_stock", %{reserved_stock: reserved_stock} do
      assert {:ok, %ReservedStock{}} = Stocks.delete_reserved_stock(reserved_stock)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_reserved_stock!(reserved_stock.id) end
    end

    test "change_reserved_stock/1 returns a reserved_stock changeset", %{
      reserved_stock: reserved_stock
    } do
      assert %Ecto.Changeset{} = Stocks.change_reserved_stock(reserved_stock)
    end
  end

  defp create_reserved_stock_with_assoc(params \\ []) do
    :perfume
    |> build()
    |> then(&build(:stock, perfume: &1))
    |> then(&build(:reserved_stock, stock: &1))
    |> then(&insert(:order, [reserved_stocks: [&1]] ++ params))
    |> Map.get(:reserved_stocks)
    |> List.first()
  end
end
