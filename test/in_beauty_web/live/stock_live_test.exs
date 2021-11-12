defmodule InBeautyWeb.StockLiveTest do
  use InBeautyWeb.ConnCase

  import Phoenix.LiveViewTest

  import InBeautyWeb.Factory, only: [insert: 1, params_for: 1]

  @create_attrs %{image_path: "some image_path", price: 42, quantity: 42, volume: 42, weight: 42}
  @update_attrs %{
    image_path: "some updated image_path",
    price: 43,
    quantity: 43,
    volume: 43,
    weight: 43
  }
  @invalid_attrs %{image_path: nil, price: nil, quantity: nil, volume: nil, weight: nil}

  setup do
    {:ok, %{stock: insert(:stock)}}
  end

  describe "Index" do
    test "lists all stocks", %{conn: conn, stock: stock} do
      {:ok, _index_live, html} = live(conn, Routes.stock_index_path(conn, :index))

      assert html =~ "Listing Stocks"
      assert html =~ stock.image_path
    end
  end

  describe "Show" do
    test "displays stock", %{conn: conn, stock: stock} do
      {:ok, _show_live, html} = live(conn, Routes.stock_show_path(conn, :show, stock))

      assert html =~ "Show Stock"
      assert html =~ stock.image_path
    end
  end
end
