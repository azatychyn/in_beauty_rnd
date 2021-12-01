defmodule InBeauty.Relations.StockOrder do
  @moduledoc """
  Module that provides StockOrder schema and its changesets
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "stocks_orders" do
    field :quantity, :integer, default: 0
    field :volume, :integer

    belongs_to :order, InBeauty.Payments.Order
    belongs_to :stock, InBeauty.Stocks.Stock
  end

  @doc false
  def changeset(stock_order, attrs) do
    stock_order
    |> cast(attrs, [:order_id, :stock_id, :quantity, :volume])
    |> validate_required([:stock_id, :volume, :quantity])
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:stock_id)
    |> unique_constraint([:stock_id, :volume, :quantity, :order_id])
  end
end
