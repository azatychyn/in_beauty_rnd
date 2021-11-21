defmodule InBeauty.Repo.Migrations.CreateCartsTable do
  use Ecto.Migration

  def change do
    create table(:carts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :anon, :boolean, default: false, null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :session_id, :binary_id

      timestamps()
    end

    create_if_not_exists unique_index(:carts, [:session_id])
  end
end
