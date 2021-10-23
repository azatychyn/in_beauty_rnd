defmodule InBeauty.CatalogueFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InBeauty.Catalogue` context.
  """

  @doc """
  Generate a perfume.
  """
  def perfume_fixture(attrs \\ %{}) do
    {:ok, perfume} =
      attrs
      |> Enum.into(%{
        description: "some description",
        gender: "some gender",
        manufacturer: "some manufacturer",
        name: "some name"
      })
      |> InBeauty.Catalogue.create_perfume()

    perfume
  end
end
