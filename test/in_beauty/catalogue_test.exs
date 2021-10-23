defmodule InBeauty.CatalogueTest do
  use InBeauty.DataCase

  alias InBeauty.Catalogue

  describe "perfumes" do
    alias InBeauty.Catalogue.Perfume

    import InBeauty.CatalogueFixtures

    @invalid_attrs %{description: nil, gender: nil, manufacturer: nil, name: nil}

    test "list_perfumes/0 returns all perfumes" do
      perfume = perfume_fixture()
      assert Catalogue.list_perfumes() == [perfume]
    end

    test "get_perfume!/1 returns the perfume with given id" do
      perfume = perfume_fixture()
      assert Catalogue.get_perfume!(perfume.id) == perfume
    end

    test "create_perfume/1 with valid data creates a perfume" do
      valid_attrs = %{
        description: "some description",
        gender: "some gender",
        manufacturer: "some manufacturer",
        name: "some name"
      }

      assert {:ok, %Perfume{} = perfume} = Catalogue.create_perfume(valid_attrs)
      assert perfume.description == "some description"
      assert perfume.gender == "some gender"
      assert perfume.manufacturer == "some manufacturer"
      assert perfume.name == "some name"
    end

    test "create_perfume/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalogue.create_perfume(@invalid_attrs)
    end

    test "update_perfume/2 with valid data updates the perfume" do
      perfume = perfume_fixture()

      update_attrs = %{
        description: "some updated description",
        gender: "some updated gender",
        manufacturer: "some updated manufacturer",
        name: "some updated name"
      }

      assert {:ok, %Perfume{} = perfume} = Catalogue.update_perfume(perfume, update_attrs)
      assert perfume.description == "some updated description"
      assert perfume.gender == "some updated gender"
      assert perfume.manufacturer == "some updated manufacturer"
      assert perfume.name == "some updated name"
    end

    test "update_perfume/2 with invalid data returns error changeset" do
      perfume = perfume_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalogue.update_perfume(perfume, @invalid_attrs)
      assert perfume == Catalogue.get_perfume!(perfume.id)
    end

    test "delete_perfume/1 deletes the perfume" do
      perfume = perfume_fixture()
      assert {:ok, %Perfume{}} = Catalogue.delete_perfume(perfume)
      assert_raise Ecto.NoResultsError, fn -> Catalogue.get_perfume!(perfume.id) end
    end

    test "change_perfume/1 returns a perfume changeset" do
      perfume = perfume_fixture()
      assert %Ecto.Changeset{} = Catalogue.change_perfume(perfume)
    end
  end
end
