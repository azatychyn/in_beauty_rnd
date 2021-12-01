# TODO to make factory to test delivery
# defmodule InBeauty.DeliveriesTest do
#   use InBeauty.DataCase

#   import InBeautyWeb.Factory,
#     only: [
#       build: 1,
#       build: 2,
#       build_pair: 2,
#       insert: 2,
#       insert_pair: 2,
#       params_for: 1
#     ]

#   alias InBeauty.{Deliveries, Stocks}
#   alias InBeauty.Deliveries.Order

#   @invalid_attrs %{paid: "some"}

#   describe "Deliveries" do
#     setup do
#       [delivery, alt_delivery] = create_delivery_with_assoc()
#       [delivery: delivery, alt_delivery: alt_delivery]
#     end

#     test "list_deliverys/0 returns all", %{delivery: %{id: id}, alt_delivery: %{id: alt_id}} do
#       assert [%{id: ^id}, %{id: ^alt_id}] = Deliveries.list_deliverys()
#     end

#     test "get_delivery!/1 returns the delivery with given id", %{delivery: delivery} do
#       assert %Order{} = fetched_delivery = Deliveries.get_delivery!(delivery.id)
#       assert delivery.comment == fetched_delivery.comment
#       assert delivery.discount == fetched_delivery.discount
#       assert delivery.email == fetched_delivery.email
#       assert delivery.first_name == fetched_delivery.first_name
#       assert delivery.last_name == fetched_delivery.last_name
#       assert delivery.patronymic == fetched_delivery.patronymic
#       assert delivery.phone_number == fetched_delivery.phone_number
#       assert delivery.paid == fetched_delivery.paid
#       assert delivery.total_price == fetched_delivery.total_price
#       assert delivery.status == fetched_delivery.status
#       assert delivery.product_price == fetched_delivery.product_price
#       assert delivery.user_id == fetched_delivery.user_id
#     end

#     test "get_delivery_by/1 returns the delivery with given id", %{delivery: delivery} do
#       assert %Order{} = fetched_delivery = Deliveries.get_delivery_by(id: delivery.id, paid: delivery.paid)
#       assert delivery.comment == fetched_delivery.comment
#       assert delivery.discount == fetched_delivery.discount
#       assert delivery.email == fetched_delivery.email
#       assert delivery.first_name == fetched_delivery.first_name
#       assert delivery.last_name == fetched_delivery.last_name
#       assert delivery.patronymic == fetched_delivery.patronymic
#       assert delivery.phone_number == fetched_delivery.phone_number
#       assert delivery.paid == fetched_delivery.paid
#       assert delivery.total_price == fetched_delivery.total_price
#       assert delivery.status == fetched_delivery.status
#       assert delivery.product_price == fetched_delivery.product_price
#       assert delivery.user_id == fetched_delivery.user_id
#     end

#     test "create_delivery/1 with valid data creates a delivery" do
#       delivery_params = params_for(:delivery)
#       assert {:ok, delivery} = Deliveries.create_delivery(delivery_params)
#       assert delivery.comment == delivery_params.comment
#       assert delivery.discount == delivery_params.discount
#       assert delivery.email == delivery_params.email
#       assert delivery.first_name == delivery_params.first_name
#       assert delivery.last_name == delivery_params.last_name
#       assert delivery.patronymic == delivery_params.patronymic
#       assert delivery.phone_number == delivery_params.phone_number
#       assert delivery.paid == delivery_params.paid
#       assert delivery.total_price == delivery_params.total_price
#       assert delivery.status == delivery_params.status
#       assert delivery.product_price == delivery_params.product_price
#     end

#     test "create_delivery/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Deliveries.create_delivery(@invalid_attrs)
#     end

#     test "update_delivery/2 with valid data updates the delivery", %{delivery: delivery} do
#       delivery_params = params_for(:delivery)

#       assert {:ok, updated_delivery} = Deliveries.update_delivery(delivery, delivery_params)
#       assert delivery_params.comment == updated_delivery.comment
#       assert delivery_params.discount == updated_delivery.discount
#       assert delivery_params.email == updated_delivery.email
#       assert delivery_params.first_name == updated_delivery.first_name
#       assert delivery_params.last_name == updated_delivery.last_name
#       assert delivery_params.patronymic == updated_delivery.patronymic
#       assert delivery_params.phone_number == updated_delivery.phone_number
#       assert delivery_params.paid == updated_delivery.paid
#       assert delivery_params.total_price == updated_delivery.total_price
#       assert delivery_params.status == updated_delivery.status
#       assert delivery_params.product_price == updated_delivery.product_price
#     end

#     test "update_delivery/2 with invalid data returns error changeset", %{delivery: delivery} do
#       assert {:error, %Ecto.Changeset{}} = Deliveries.update_delivery(delivery, @invalid_attrs)
#       assert %Order{} = fetched_delivery = Deliveries.get_delivery!(delivery.id)
#       assert delivery.comment == fetched_delivery.comment
#       assert delivery.discount == fetched_delivery.discount
#       assert delivery.email == fetched_delivery.email
#       assert delivery.first_name == fetched_delivery.first_name
#       assert delivery.last_name == fetched_delivery.last_name
#       assert delivery.patronymic == fetched_delivery.patronymic
#       assert delivery.phone_number == fetched_delivery.phone_number
#       assert delivery.paid == fetched_delivery.paid
#       assert delivery.total_price == fetched_delivery.total_price
#       assert delivery.status == fetched_delivery.status
#       assert delivery.product_price == fetched_delivery.product_price
#       assert delivery.user_id == fetched_delivery.user_id
#     end

#     test "change_delivery/1 returns a delivery changeset", %{delivery: delivery} do
#       assert %Ecto.Changeset{} = Deliveries.change_delivery(delivery)
#     end
#   end

#   describe "Delete delivery" do
#     setup do
#       [delivery, _] = create_delivery_with_assoc()
#       [delivery: delivery]
#     end

#     test "delete_delivery/1 deletes the delivery with all child reserved_stocks", %{delivery: delivery} do
#       delivery = InBeauty.Repo.preload(delivery, [:stocks])
#       assert {:ok, %Order{}} = Deliveries.delete_delivery(delivery)
#       assert_raise Ecto.NoResultsError, fn -> Deliveries.get_delivery!(delivery.id) end

#       for reserved_stock <- delivery.reserved_stocks do
#         assert_raise Ecto.NoResultsError, fn -> Stocks.get_reserved_stock!(reserved_stock.id) end
#       end
#     end

#     # TODO to think hot to do a postgres error
#     # test "delete_delivery/1 error in deletion and save all child reserved_stocks", %{delivery: delivery} do
#     #   delivery = InBeauty.Repo.preload(delivery, [:stocks])
#     #   assert {:ok, %Order{}} = Deliveries.delete_delivery(delivery)
#     #   assert_raise Ecto.NoResultsError, fn -> Deliveries.get_delivery!(delivery.id) end

#     #   for reserved_stock <- delivery.reserved_stocks do
#     #     assert_raise Ecto.NoResultsError, fn -> Stocks.get_reserved_stock!(reserved_stock.id) end
#     #   end
#     # end
#   end

#   describe "Filter deliverys" do
#     setup do
#       create_delivery_with_assoc(paid: true, status: "create", total_price: 100.0)
#       create_delivery_with_assoc(status: "confirm", total_price: 200.0)

#       []
#     end

#     test "list_deliverys/1 returns filtered deliverys by confirm status" do
#       assert 2 == count_by_params(%{statuses: ["confirm"]})
#     end

#     test "list_deliverys/1 returns filtered deliverys by all statuses" do
#       assert 4 == count_by_params(%{statuses: ["confirm", "create"]})
#     end

#     test "list_deliverys/1 returns filtered all paid deliverys" do
#       assert 2 == count_by_params(%{paid: true})
#     end

#     test "list_deliverys/1 returns filtered all unpaid deliverys" do
#       assert 2 == count_by_params(%{paid: false})
#     end

#     test "list_deliverys/1 returns filtered deliverys by total price(integer)" do
#       assert 4 == count_by_params(%{total_price: ["100", "200"]})

#       assert 2 == count_by_params(%{total_price: ["101", "200"]})

#       assert 2 == count_by_params(%{total_price: ["10", "100"]})
#     end

#     test "list_deliverys/1 returns filtered deliverys by total price(float)" do
#       assert 4 == count_by_params(%{total_price: ["100.0", "200.0"]})

#       assert 2 == count_by_params(%{total_price: ["101.0", "200.0"]})

#       assert 2 == count_by_params(%{total_price: ["10.0", "100.0"]})
#     end

#     test "list_deliverys/1 returns all deliverys exept filter" do
#       assert 4 == count_by_params(%{})

#       assert 4 == count_by_params(%{some: ["filter"]})
#     end
#   end

#   describe "Count deliverys" do
#     setup do
#       create_delivery_with_assoc(status: "create")
#       create_delivery_with_assoc(status: "confirm")
#       []
#     end

#     test "count_deliverys/1 count all confirm deliverys" do
#       assert 2 == Deliveries.count_deliverys(%{statuses: ["confirm"]})
#     end

#     test "count_deliverys/1 count all create deliverys" do
#       assert 2 == Deliveries.count_deliverys(%{statuses: ["create"]})
#     end

#     test "count_deliverys/1 count all statuses" do
#       assert 4 == Deliveries.count_deliverys(%{statuses: ["confirm", "create"]})
#     end
#   end

#   defp count_by_params(params) do
#     params
#     |> Deliveries.list_deliverys()
#     |> Map.get(:entries)
#     |> length()
#   end

#   defp create_delivery_with_assoc(params \\ []) do
#     :perfume
#     |> build()
#     |> then(&build(:stock, perfume: &1))
#     |> then(&build_pair(:reserved_stock, stock: &1))
#     |> then(&insert_pair(:delivery, [reserved_stocks: &1] ++ params))
#   end
# end
