defmodule InBeauty.Relations.StockCart do
  @typedoc """
      Module that provides StockCart schema and its changesets
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "stocks_carts" do
    field :quantity, :integer, default: 0
    field :volume, :integer
    # TODO make columes enums and validate them

    belongs_to :cart, InBeauty.Carts.Cart
    belongs_to :stock, InBeauty.Stocks.Stock
  end

  @doc false
  def changeset(stock_cart, attrs) do
    stock_cart
    |> cast(attrs, [:cart_id, :stock_id, :quantity, :volume])
    |> validate_required([:cart_id, :stock_id, :volume, :quantity])
    |> foreign_key_constraint(:cart_id)
    |> foreign_key_constraint(:stock_id)
    |> unique_constraint([:cart_id, :stock_id, :volume])
  end
end
