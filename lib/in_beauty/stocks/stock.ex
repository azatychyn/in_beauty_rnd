defmodule InBeauty.Stocks.Stock do
  use Ecto.Schema
  import Ecto.Changeset

  alias InBeauty.Catalogue.Perfume

  @fields ~w(image_path price quantity volume weight perfume_id)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "stocks" do
    field :image_path, :string
    field :price, :integer
    field :quantity, :integer
    field :volume, :integer
    field :weight, :integer
    field :delete, :boolean, virtual: true

    belongs_to :perfume, Perfume

    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:volume, :perfume_id])
    |> foreign_key_constraint(:perfume_id)
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
