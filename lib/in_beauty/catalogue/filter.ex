defmodule InBeauty.Catalogue.Filter do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(genders manufacturers page page_size price volumes)a
  @type t :: %__MODULE__{
          page: pos_integer,
          page_size: pos_integer,
          genders: list,
          volumes: list,
          manufacturers: list,
          price: [non_neg_integer, ...]
        }

  @primary_key false
  @derive {Jason.Encoder, only: @fields}
  schema "filters" do
    field :genders, {:array, Ecto.Enum}, values: [:men, :women, :unisex], default: []
    field :manufacturers, {:array, :string}, default: []
    field :page, :integer, default: 1
    field :page_size, :integer, default: 20
    field :price, {:array, :string}, default: ["0", "10000"]
    field :volumes, {:array, :string}, default: []
  end

  @doc false
  def changeset(perfume, attrs) do
    perfume
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
