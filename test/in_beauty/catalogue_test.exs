defmodule InBeauty.CatalogueTest do
  use InBeauty.DataCase

  import InBeautyWeb.Factory,
    only: [build: 1, insert: 1, insert: 2, params_for: 1, build_list: 3]

  alias InBeauty.{Catalogue, Stocks}
  alias InBeauty.Catalogue.Perfume

  @invalid_attrs %{description: nil, gender: nil, manufacturer: nil, name: nil}

  describe "perfumes" do
    setup do
      %{perfume: insert(:perfume)}
    end

    test "list_perfumes/0 returns all perfumes", %{perfume: perfume} do
      assert Catalogue.list_perfumes() == [perfume]
    end

    test "get_perfume!/1 returns the perfume with given id", %{perfume: perfume} do
      assert Catalogue.get_perfume!(perfume.id) == perfume
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
      assert perfume == Catalogue.get_perfume!(perfume.id)
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
      assert 2 ==
               %{manufacturers: ["Apple"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()

      assert 3 ==
               %{manufacturers: ["Apple", "Arfashor"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()
    end

    test "list_perfumes/1 returns error on filtering perfumes when manufacturer's name is not full" do
      assert 0 ==
               %{manufacturers: ["some_"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()
    end

    test "list_perfumes/1 returns filtered perfumes by genders" do
      assert 3 ==
               %{genders: ["men"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()

      assert 4 ==
               %{genders: ["men", "unisex"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()
    end

    test "list_perfumes/1 returns error on filtering perfumes when genders's name is incorrect" do
      assert 0 ==
               %{genders: ["womens"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()
    end

    test "list_perfumes/1 returns error on filtering perfumes by prices" do
      assert 3 ==
               %{price: ["0", "250"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()
    end

    test "list_perfumes/1 returns error on filtering perfumes by volumes" do
      assert 2 ==
               %{volumes: ["20", "100"]}
               |> Catalogue.list_perfumes()
               |> Map.get(:entries)
               |> length()
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
end
