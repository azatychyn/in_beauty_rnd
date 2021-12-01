defmodule InBeauty.PaymentsTest do
  use InBeauty.DataCase

  import InBeautyWeb.Factory,
    only: [
      build: 1,
      build: 2,
      build_pair: 2,
      insert: 2,
      insert_pair: 2,
      params_for: 1
    ]

  alias InBeauty.{Payments, Stocks}
  alias InBeauty.Payments.Order

  @invalid_attrs %{paid: "some"}

  describe "Payments" do
    setup do
      [order, alt_order] = create_order_with_assoc()
      [order: order, alt_order: alt_order]
    end

    test "list_orders/0 returns all", %{order: %{id: id}, alt_order: %{id: alt_id}} do
      assert [%{id: ^id}, %{id: ^alt_id}] = Payments.list_orders()
    end

    test "get_order!/1 returns the order with given id", %{order: order} do
      assert %Order{} = fetched_order = Payments.get_order!(order.id)
      assert order.comment == fetched_order.comment
      assert order.discount == fetched_order.discount
      assert order.email == fetched_order.email
      assert order.first_name == fetched_order.first_name
      assert order.last_name == fetched_order.last_name
      assert order.patronymic == fetched_order.patronymic
      assert order.phone_number == fetched_order.phone_number
      assert order.paid == fetched_order.paid
      assert order.total_price == fetched_order.total_price
      assert order.status == fetched_order.status
      assert order.product_price == fetched_order.product_price
      assert order.user_id == fetched_order.user_id
    end

    test "get_order_by/1 returns the order with given id", %{order: order} do
      assert %Order{} = fetched_order = Payments.get_order_by(id: order.id, paid: order.paid)
      assert order.comment == fetched_order.comment
      assert order.discount == fetched_order.discount
      assert order.email == fetched_order.email
      assert order.first_name == fetched_order.first_name
      assert order.last_name == fetched_order.last_name
      assert order.patronymic == fetched_order.patronymic
      assert order.phone_number == fetched_order.phone_number
      assert order.paid == fetched_order.paid
      assert order.total_price == fetched_order.total_price
      assert order.status == fetched_order.status
      assert order.product_price == fetched_order.product_price
      assert order.user_id == fetched_order.user_id
    end

    test "create_order/1 with valid data creates a order" do
      order_params = params_for(:order)
      assert {:ok, order} = Payments.create_order(order_params)
      assert order.comment == order_params.comment
      assert order.discount == order_params.discount
      assert order.email == order_params.email
      assert order.first_name == order_params.first_name
      assert order.last_name == order_params.last_name
      assert order.patronymic == order_params.patronymic
      assert order.phone_number == order_params.phone_number
      assert order.paid == order_params.paid
      assert order.total_price == order_params.total_price
      assert order.status == order_params.status
      assert order.product_price == order_params.product_price
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order", %{order: order} do
      order_params = params_for(:order)

      assert {:ok, updated_order} = Payments.update_order(order, order_params)
      assert order_params.comment == updated_order.comment
      assert order_params.discount == updated_order.discount
      assert order_params.email == updated_order.email
      assert order_params.first_name == updated_order.first_name
      assert order_params.last_name == updated_order.last_name
      assert order_params.patronymic == updated_order.patronymic
      assert order_params.phone_number == updated_order.phone_number
      assert order_params.paid == updated_order.paid
      assert order_params.total_price == updated_order.total_price
      assert order_params.status == updated_order.status
      assert order_params.product_price == updated_order.product_price
    end

    test "update_order/2 with invalid data returns error changeset", %{order: order} do
      assert {:error, %Ecto.Changeset{}} = Payments.update_order(order, @invalid_attrs)
      assert %Order{} = fetched_order = Payments.get_order!(order.id)
      assert order.comment == fetched_order.comment
      assert order.discount == fetched_order.discount
      assert order.email == fetched_order.email
      assert order.first_name == fetched_order.first_name
      assert order.last_name == fetched_order.last_name
      assert order.patronymic == fetched_order.patronymic
      assert order.phone_number == fetched_order.phone_number
      assert order.paid == fetched_order.paid
      assert order.total_price == fetched_order.total_price
      assert order.status == fetched_order.status
      assert order.product_price == fetched_order.product_price
      assert order.user_id == fetched_order.user_id
    end

    test "change_order/1 returns a order changeset", %{order: order} do
      assert %Ecto.Changeset{} = Payments.change_order(order)
    end
  end

  describe "Delete order" do
    setup do
      [order, _] = create_order_with_assoc()
      [order: order]
    end

    test "delete_order/1 deletes the order with all child reserved_stocks", %{order: order} do
      order = InBeauty.Repo.preload(order, [:stocks])
      assert {:ok, %Order{}} = Payments.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_order!(order.id) end

      for reserved_stock <- order.reserved_stocks do
        assert_raise Ecto.NoResultsError, fn -> Stocks.get_reserved_stock!(reserved_stock.id) end
      end
    end

    # TODO to think hot to do a postgres error
    # test "delete_order/1 error in deletion and save all child reserved_stocks", %{order: order} do
    #   order = InBeauty.Repo.preload(order, [:stocks])
    #   assert {:ok, %Order{}} = Payments.delete_order(order)
    #   assert_raise Ecto.NoResultsError, fn -> Payments.get_order!(order.id) end

    #   for reserved_stock <- order.reserved_stocks do
    #     assert_raise Ecto.NoResultsError, fn -> Stocks.get_reserved_stock!(reserved_stock.id) end
    #   end
    # end
  end

  describe "Filter orders" do
    setup do
      create_order_with_assoc(paid: true, status: "create", total_price: 100.0)
      create_order_with_assoc(status: "confirm", total_price: 200.0)

      []
    end

    test "list_orders/1 returns filtered orders by confirm status" do
      assert 2 == count_by_params(%{statuses: ["confirm"]})
    end

    test "list_orders/1 returns filtered orders by all statuses" do
      assert 4 == count_by_params(%{statuses: ["confirm", "create"]})
    end

    test "list_orders/1 returns filtered all paid orders" do
      assert 2 == count_by_params(%{paid: true})
    end

    test "list_orders/1 returns filtered all unpaid orders" do
      assert 2 == count_by_params(%{paid: false})
    end

    test "list_orders/1 returns filtered orders by total price(integer)" do
      assert 4 == count_by_params(%{total_price: ["100", "200"]})

      assert 2 == count_by_params(%{total_price: ["101", "200"]})

      assert 2 == count_by_params(%{total_price: ["10", "100"]})
    end

    test "list_orders/1 returns filtered orders by total price(float)" do
      assert 4 == count_by_params(%{total_price: ["100.0", "200.0"]})

      assert 2 == count_by_params(%{total_price: ["101.0", "200.0"]})

      assert 2 == count_by_params(%{total_price: ["10.0", "100.0"]})
    end

    test "list_orders/1 returns all orders exept filter" do
      assert 4 == count_by_params(%{})

      assert 4 == count_by_params(%{some: ["filter"]})
    end
  end

  describe "Count orders" do
    setup do
      create_order_with_assoc(status: "create")
      create_order_with_assoc(status: "confirm")
      []
    end

    test "count_orders/1 count all confirm orders" do
      assert 2 == Payments.count_orders(%{statuses: ["confirm"]})
    end

    test "count_orders/1 count all create orders" do
      assert 2 == Payments.count_orders(%{statuses: ["create"]})
    end

    test "count_orders/1 count all statuses" do
      assert 4 == Payments.count_orders(%{statuses: ["confirm", "create"]})
    end
  end

  defp count_by_params(params) do
    params
    |> Payments.list_orders()
    |> Map.get(:entries)
    |> length()
  end

  defp create_order_with_assoc(params \\ []) do
    :perfume
    |> build()
    |> then(&build(:stock, perfume: &1))
    |> then(&build_pair(:reserved_stock, stock: &1))
    |> then(&insert_pair(:order, [reserved_stocks: &1] ++ params))
  end
end
