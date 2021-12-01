defmodule InBeauty.CartsTest do
  use InBeauty.DataCase

  import InBeautyWeb.Factory,
    only: [
      build: 1,
      build: 2,
      build_pair: 2,
      build_pair: 1,
      insert: 1,
      insert: 2,
      insert_pair: 1,
      insert_pair: 2,
      params_for: 1,
      params_for: 2
    ]

  alias InBeauty.{Carts, Relations}
  alias InBeauty.Carts.Cart

  @invalid_attrs %{anon: "some"}

  describe "Carts" do
    setup do
      %{cart: insert(:cart)}
    end

    test("list_carts/0 returns all", %{cart: cart}, do: assert(Carts.list_carts() == [cart]))

    test("get_cart!/1 returns the cart with given id", %{cart: cart},
      do: assert(Carts.get_cart!(cart.id) == cart)
    )

    test("get_cart_by/1 returns the cart with given id", %{cart: cart},
      do: assert(Carts.get_cart_by(id: cart.id, anon: cart.anon) == cart)
    )

    test "create_cart/1 with valid data creates a cart" do
      cart_params = params_for(:cart)
      assert {:ok, cart} = Carts.create_cart(cart_params)
      assert cart.anon == cart_params.anon
      assert cart.product_count == 0
      assert cart.total_price == 0.0
    end

    test "create_cart/1 with invalid data returns error changeset",
      do: assert({:error, %Ecto.Changeset{}} = Carts.create_cart(@invalid_attrs))

    test "update_cart/2 with valid data updates the cart", %{cart: cart} do
      cart_params = params_for(:cart, anon: true)

      assert {:ok, cart} = Carts.update_cart(cart, cart_params)
      assert cart.anon == cart_params.anon
    end

    test "update_cart/2 with invalid data returns error changeset", %{cart: cart} do
      assert {:error, %Ecto.Changeset{}} = Carts.update_cart(cart, @invalid_attrs)
      assert cart == Carts.get_cart!(cart.id)
    end

    test "change_cart/1 returns a cart changeset", %{cart: cart} do
      assert %Ecto.Changeset{} = Carts.change_cart(cart)
    end
  end

  describe "Delete cart" do
    setup do
      stock = insert(:stock)
      stock_cart = build(:stock_cart, volume: 20, stock: stock, stock_id: stock.id)
      alt_stock_cart = build(:stock_cart, volume: 40, stock: stock, stock_id: stock.id)
      [cart: insert(:cart, stocks_carts: [stock_cart, alt_stock_cart])]
    end

    test "delete_cart/1 deletes the cart with all child stocks", %{cart: cart} do
      cart = InBeauty.Repo.preload(cart, [:stocks])
      assert {:ok, %Cart{}} = Carts.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_cart!(cart.id) end

      for stock_cart <- cart.stocks_carts do
        assert_raise Ecto.NoResultsError, fn -> Relations.get_stock_cart!(stock_cart.id) end
      end
    end
  end

  describe "Filter carts" do
    setup do
      insert_pair(:cart)
      insert_pair(:cart, anon: true)
      []
    end

    test "count_carts/1 count all anon carts",
      do: assert(2 == Carts.count_carts(%{roles: ["anon", ""]}))

    test "list_carts/1 returns filtered carts by anon",
      do: assert(2 == count_by_params(%{roles: ["anon", ""]}))

    test "list_carts/1 returns filtered carts by user",
      do: assert(2 == count_by_params(%{roles: ["user", ""]}))

    test "list_carts/1 returns all carts without filter" do
      assert 4 == count_by_params(%{roles: ["user"]})
      assert 4 == count_by_params(%{roles: ["anon"]})
    end
  end

  describe "Count carts" do
    setup do
      user = insert(:user)
      insert_pair(:cart, user: user)
      insert_pair(:cart, anon: true, user: user)
      []
    end

    test "count_carts/1 count all anon carts",
      do: assert(2 == Carts.count_carts(%{roles: ["anon", ""]}))

    test "count_carts/1 count all users carts",
      do: assert(2 == Carts.count_carts(%{roles: ["user", ""]}))

    test "count_carts/1 count all carts", do: assert(4 == Carts.count_carts(%{}))
  end

  describe "Generate product_count && total_price" do
    setup do
      stock = insert(:stock)
      stock_cart = build(:stock_cart, volume: 20, quantity: 8, stock: stock, stock_id: stock.id)

      alt_stock_cart =
        build(:stock_cart, volume: 40, quantity: 10, stock: stock, stock_id: stock.id)

      [cart: insert(:cart, stocks_carts: [stock_cart, alt_stock_cart])]
    end

    test "add_cart_attrs/1 generate total price && product_count", %{cart: cart} do
      price =
        cart
        |> InBeauty.Repo.preload([:stocks])
        |> Map.get(:stocks)
        |> Stream.map(& &1.price)
        |> Enum.sum()

      assert %Cart{product_count: 18, total_price: total_price} = Carts.add_cart_attrs(cart)
      assert total_price == 9 * price
    end
  end

  defp count_by_params(params) do
    params
    |> Carts.list_carts()
    |> Map.get(:entries)
    |> length()
  end
end
