# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InBeauty.Repo.insert!(%InBeauty.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

1..10000
|> Enum.map(fn i ->
  InBeauty.Catalogue.create_perfume(%{
    description: "some desc#{i}",
    name: "GUCCI the alchemist's garden the voice of the snake eau de parfum_#{i}",
    gender: Enum.random(["men", "women", "unisex"]),
    manufacturer: "some manufacturer"
  })
end)
|> Enum.map(fn {:ok, perfume} ->
  Enum.map(1..4, fn i ->
    InBeauty.Stocks.create_stock(%{
      price: Enum.random(1..1000),
      volume: Enum.at([30, 40, 50, 100, 200], i - 1),
      quantity: Enum.random(0..3),
      weight: 100,
      image_path:
        " https://images.unsplash.com/photo-1541643600914-78b084683601?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=404&q=80",
      perfume_id: perfume.id
    })
  end)
end)
