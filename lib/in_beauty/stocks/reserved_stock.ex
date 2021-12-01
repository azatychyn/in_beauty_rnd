defmodule InBeauty.Stocks.ReservedStock do
  use Ecto.Schema

  import Ecto.Changeset

  # alias InBeauty.MediaData.Image
  alias InBeauty.Stocks.Stock
  alias InBeauty.Payments.Order

  @fields ~w(stock_id order_id quantity volume)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "reserved_stocks" do
    field :quantity, :integer
    field :volume, :integer

    belongs_to :stock, Stock
    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, __MODULE__.__schema__(:fields))
    |> unique_constraint([:order_id, :stock_id, :volume])
    |> foreign_key_constraint(:stock_id)
    |> foreign_key_constraint(:order_id)
    # TODO add all fields to validate
    |> validate_required(@fields)
  end
end
