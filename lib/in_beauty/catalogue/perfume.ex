defmodule InBeauty.Catalogue.Perfume do
  use Ecto.Schema
  import Ecto.Changeset
  alias InBeauty.Stocks.Stock
  @fields ~w(description gender name manufacturer)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "perfumes" do
    field :description, :string
    field :gender, Ecto.Enum, values: [:men, :women, :unisex]
    field :manufacturer, :string
    field :name, :string

    has_many :stocks, Stock, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(perfume, attrs) do
    perfume
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
