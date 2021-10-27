defmodule InBeauty.Catalogue do
  @moduledoc """
  The Catalogue context.
  """

  import Ecto.Query, warn: false
  alias InBeauty.Repo

  alias InBeauty.Catalogue.Perfume
  alias InBeauty.Stocks.Stock

  @doc """
  Returns the list of perfumes.

  ## Examples

      iex> list_perfumes()
      [%Perfume{}, ...]

  """
  def list_perfumes do
    Perfume
    |> preload([:stocks])
    |> Repo.all()
  end

  @doc """
  Returns the filtered list of perfumes.

  ## Examples

      iex> list_perfumes()
      [%Perfume{}, ...]

  """
  def list_perfumes(params) when is_map(params) do
    Perfume
    |> join(:left, [p], s in Stock, on: s.perfume_id == p.id)
    |> preload([p, s], stocks: s)
    |> filter_genders(params)
    |> filter_manufacturers(params)
    |> sort(params)
    |> filter_price(params)
    |> filter_volumes(params)
    |> distinct([p, s], p.id)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single perfume.

  Raises `Ecto.NoResultsError` if the Perfume does not exist.

  ## Examples

      iex> get_perfume!(123)
      %Perfume{}

      iex> get_perfume!(456)
      ** (Ecto.NoResultsError)

  """
  def get_perfume!(id) do
    Perfume
    |> preload([:stocks])
    |> Repo.get!(id)
  end

  @doc """
  Creates a perfume.

  ## Examples

      iex> create_perfume(%{field: value})
      {:ok, %Perfume{}}

      iex> create_perfume(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_perfume(attrs \\ %{}) do
    %Perfume{}
    |> Perfume.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a perfume.

  ## Examples

      iex> update_perfume(perfume, %{field: new_value})
      {:ok, %Perfume{}}

      iex> update_perfume(perfume, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_perfume(%Perfume{} = perfume, attrs) do
    perfume
    |> Repo.preload([:stocks])
    |> Perfume.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a perfume.

  ## Examples

      iex> delete_perfume(perfume)
      {:ok, %Perfume{}}

      iex> delete_perfume(perfume)
      {:error, %Ecto.Changeset{}}

  """
  def delete_perfume(%Perfume{} = perfume) do
    Repo.delete(perfume)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking perfume changes.

  ## Examples

      iex> change_perfume(perfume)
      %Ecto.Changeset{data: %Perfume{}}

  """
  def change_perfume(%Perfume{} = perfume, attrs \\ %{}) do
    Perfume.changeset(perfume, attrs)
  end

  @doc """
  Returns the list of manufacturers with filtering.

  ## Examples

      iex> list_manufacturers()
      [manufacturer, ...]

  """
  def list_manufacturers() do
    Perfume
    |> distinct([p], p.manufacturer)
    |> select([p], p.manufacturer)
    |> Repo.all()
  end

  defp filter_volumes(query, %{volumes: volumes})
       when volumes not in [[""], [], ""] do
    volumes =
      volumes
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)

    where(query, [p, s], s.volume in ^volumes)
  end

  defp filter_volumes(query, _), do: query

  defp filter_price(query, %{price: [min, max]}) do
    min = String.to_integer(min)
    max = String.to_integer(max)

    where(query, [_p, s], s.price >= ^min and s.price <= ^max)
  end

  defp filter_price(query, _), do: query

  defp filter_genders(query, %{genders: genders})
       when genders not in [[""], [], ""] do
    gender_enums = Ecto.Enum.dump_values(Perfume, :gender)
    gender_enums_atoms = Ecto.Enum.values(Perfume, :gender)
    filtered_genders = Enum.filter(genders, &(&1 in (gender_enums_atoms ++ gender_enums)))
    where(query, [q], q.gender in ^filtered_genders)
  end

  defp filter_genders(query, _), do: query

  defp filter_manufacturers(query, %{manufacturers: manufacturers})
       when manufacturers not in [[""], [], ""],
       do: where(query, [q], q.manufacturer in ^manufacturers)

  defp filter_manufacturers(query, _), do: query

  defp sort(query, %{sort: %{sort_by: sort_by, sort_order: sort_order}}),
    do: order_by(query, [{^sort_order, ^sort_by}])

  defp sort(query, _), do: query
end
