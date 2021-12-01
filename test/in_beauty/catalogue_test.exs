defmodule InBeauty.CatalogueTest do
  use InBeauty.DataCase

  import InBeautyWeb.Factory,
    only: [
      build: 1,
      build_list: 3,
      insert: 1,
      insert: 2,
      insert_pair: 1,
      insert_pair: 2,
      params_for: 1
    ]

  alias InBeauty.{Catalogue, Stocks}
  alias InBeauty.Catalogue.Perfume

  @invalid_attrs %{description: nil, gender: nil, manufacturer: nil, name: nil}

  describe "perfumes" do
    setup do
      %{perfume: insert(:perfume)}
    end

    test "list_perfumes/0 returns all perfumes", %{perfume: %{id: id}} do
      assert [%{id: ^id}] = Catalogue.list_perfumes()
    end

    test "get_perfume!/1 returns the perfume with given id", %{perfume: perfume} do
      fetched_perfume = Catalogue.get_perfume!(perfume.id)
      assert fetched_perfume.description == perfume.description
      assert fetched_perfume.gender == perfume.gender
      assert fetched_perfume.manufacturer == perfume.manufacturer
      assert fetched_perfume.name == perfume.name
    end

    test "create_perfume/1 with valid data creates a perfume" do
      perfume_params = params_for(:perfume)
      assert {:ok, perfume} = Catalogue.create_perfume(perfume_params)
      assert perfume.description == perfume_params.description
      assert perfume.gender == perfume_params.gender
      assert perfume.manufacturer == perfume_params.manufacturer
      assert perfume.name == perfume_params.name
    end

    test "create_perfume/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_perfume(@invalid_attrs)
    end

    test "update_perfume/2 with valid data updates the perfume", %{perfume: perfume} do
      perfume_params = params_for(:perfume)

      assert {:ok, perfume} = Catalogue.update_perfume(perfume, perfume_params)
      assert perfume.description == perfume_params.description
      assert perfume.gender == perfume_params.gender
      assert perfume.manufacturer == perfume_params.manufacturer
      assert perfume.name == perfume_params.name
    end

    test "update_perfume/2 with invalid data returns error changeset", %{perfume: perfume} do
      assert {:error, %Ecto.Changeset{}} = Catalogue.update_perfume(perfume, @invalid_attrs)
      fetched_perfume = Catalogue.get_perfume!(perfume.id)
      assert fetched_perfume.description == perfume.description
      assert fetched_perfume.gender == perfume.gender
      assert fetched_perfume.manufacturer == perfume.manufacturer
      assert fetched_perfume.name == perfume.name
    end

    test "delete_perfume/1 deletes the perfume with all child stocks", %{perfume: perfume} do
      assert {:ok, %Perfume{}} = Catalogue.delete_perfume(perfume)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_perfume!(perfume.id) end

      for stock <- perfume.stocks do
        assert_raise Ecto.NoResultsError, fn -> Stocks.get_stock!(stock.id) end
      end
    end

    test "change_perfume/1 returns a perfume changeset", %{perfume: perfume} do
      assert %Ecto.Changeset{} = Catalogue.change_perfume(perfume)
    end
  end

  describe "Filter perfumes" do
    setup [:create_perfumes]

    test "list_perfumes/1 returns filtered perfumes by manufacturers" do
      assert 2 == count_by_params(%{manufacturers: ["Apple"]})

      assert 3 == count_by_params(%{manufacturers: ["Apple", "Arfashor"]})
    end

    test "list_perfumes/1 returns error on filtering perfumes when manufacturer's name is not full" do
      assert 0 == count_by_params(%{manufacturers: ["some_"]})
    end

    test "list_perfumes/1 returns filtered perfumes by genders" do
      assert 3 == count_by_params(%{genders: ["men"]})

      assert 4 == count_by_params(%{genders: ["men", "unisex"]})
    end

    test "list_perfumes/1 returns error on filtering perfumes when genders's name is incorrect" do
      assert 0 == count_by_params(%{genders: ["womens"]})
    end

    test "list_perfumes/1 returns error on filtering perfumes by prices" do
      assert 3 == count_by_params(%{price: ["0", "250"]})
    end

    test "list_perfumes/1 returns error on filtering perfumes by volumes" do
      assert 2 == count_by_params(%{volumes: ["20", "100"]})
    end
  end

  defp create_perfumes(_) do
    insert(:perfume, gender: :men, manufacturer: "some_manufactorer", stocks: [])
    insert(:perfume, gender: :women, manufacturer: "Apple", stocks: [])
    insert(:perfume, gender: :men, manufacturer: "Apple", stocks: [])
    insert(:perfume, gender: :unisex, manufacturer: "Arfashor", stocks: [build(:stock)])

    insert(:perfume,
      gender: :men,
      manufacturer: "Daz",
      stocks: build_list(3, :stock, price: 150, volume: 20)
    )

    insert(:perfume,
      gender: :women,
      manufacturer: "Daz",
      stocks: build_list(3, :stock, price: 250, volume: 100)
    )

    %{}
  end

  describe "Change filter" do
    test "change_filter/1 with empty data" do
      assert %Ecto.Changeset{valid?: true} = Catalogue.change_filter(%InBeauty.Catalogue.Filter{})
    end

    test "change_filter/2 with valid data" do
      params = %{volumes: ["100"]}

      assert ["100"] =
               %InBeauty.Catalogue.Filter{}
               |> Catalogue.change_filter(params)
               |> Ecto.Changeset.get_change(:volumes)
    end
  end

  describe "Get all manufacturers" do
    test "list_manufacturers/0 return all" do
      [perfume, alt_perfume] = insert_pair(:perfume)
      assert [perfume.manufacturer, alt_perfume.manufacturer] == Catalogue.list_manufacturers()
    end

    test "list_manufacturers/2 return all uniq" do
      [perfume, _] = insert_pair(:perfume, manufacturer: "azat")
      assert [perfume.manufacturer] == Catalogue.list_manufacturers()
    end
  end

  defp count_by_params(params) do
    params
    |> Catalogue.list_perfumes()
    |> Map.get(:entries)
    |> length()
  end
end
