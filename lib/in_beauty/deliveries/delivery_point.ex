defmodule InBeauty.Deliveries.DeliveryPoint do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :address, :string
    field :address_full, :string
    field :allowed_cod, :boolean
    field :city, :string
    field :city_code, :integer
    field :code, :string
    field :have_cash, :boolean
    field :have_cashless, :boolean
    field :is_handout, :boolean
    field :latitude, :float
    field :longitude, :float
    field :name, :string
    field :owner_code, :string
    field :type, :string
    field :work_time, :string
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, __MODULE__.__schema__(:fields))
    |> validate_required(__MODULE__.__schema__(:fields))
  end
end
