defmodule InBeauty.Repo.Migrations.CreateReservedStocksTable do
  use Ecto.Migration

  def change do
    create table(:reserved_stocks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :integer, null: false
      add :volume, :integer, null: false

      add :stock_id, references(:stocks, type: :binary_id, on_delete: :delete_all), null: false
      add :order_id, references(:orders, type: :binary_id, on_delete: :delete_all), null: false

      timestamps()
    end

    create_if_not_exists unique_index(:reserved_stocks, [:order_id, :stock_id, :volume])
  end
end
