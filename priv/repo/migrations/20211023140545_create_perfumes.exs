defmodule InBeauty.Repo.Migrations.CreatePerfumes do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE gender_type AS ENUM ('men', 'women', 'unisex')"
    drop_query = "DROP TYPE gender_type"
    execute(create_query, drop_query)

    create table(:perfumes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string, null: false
      add :gender, :string, null: false
      add :name, :string, null: false
      add :manufacturer, :string, null: false

      timestamps()
    end
  end
end
