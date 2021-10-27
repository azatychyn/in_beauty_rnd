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

    has_many :stocks, Stock
    timestamps()
  end

  @doc false
  def changeset(perfume, attrs) do
    stocks = attrs[:stocks] || attrs["stocks"]

    perfume
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> maybe_cast_stocks(stocks)
  end

  defp maybe_cast_stocks(changeset, nil), do: changeset

  defp maybe_cast_stocks(changeset, stocks),
    do: cast_assoc(changeset, :stocks, with: &Stock.changeset/2)
end
