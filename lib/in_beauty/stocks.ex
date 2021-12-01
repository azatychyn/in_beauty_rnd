defmodule InBeauty.Stocks do
  @moduledoc """
  The Stocks context.
  """

  import Ecto.Query, warn: false
  alias InBeauty.Repo

  alias InBeauty.Stocks.{ReservedStock, Stock}

  @topic inspect(__MODULE__)

  @doc """
  Returns the list of stocks.

  ## Examples

      iex> list_stocks()
      [%Stock{}, ...]

  """
  def list_stocks do
    Repo.all(Stock)
  end

  @doc """
  Gets a single stock.

  Raises `Ecto.NoResultsError` if the Stock does not exist.

  ## Examples

      iex> get_stock!(123)
      %Stock{}

      iex> get_stock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock!(id), do: Repo.get!(Stock, id)

  @doc """
  Creates a stock.

  ## Examples

      iex> create_stock(%{field: value})
      {:ok, %Stock{}}

      iex> create_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock(attrs \\ %{}) do
    %Stock{}
    |> Stock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stock.

  ## Examples

      iex> update_stock(stock, %{field: new_value})
      {:ok, %Stock{}}

      iex> update_stock(stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock(%Stock{} = stock, attrs) do
    stock
    |> Stock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stock.

  ## Examples

      iex> delete_stock(stock)
      {:ok, %Stock{}}

      iex> delete_stock(stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock(%Stock{} = stock) do
    Repo.delete(stock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock changes.

  ## Examples

      iex> change_stock(stock)
      %Ecto.Changeset{data: %Stock{}}

  """
  def change_stock(%Stock{} = stock, attrs \\ %{}) do
    Stock.changeset(stock, attrs)
  end

  @doc """
  Returns the list of volumes with filtering and pagination.

  ## Examples

      iex> list_volumes()
      [volume, ...]

  """
  def list_volumes() do
    Stock
    |> distinct([s], s.volume)
    |> select([s], s.volume)
    |> Repo.all()
  end

  @doc """
  Returns the list of reserved_stocks.

  ## Examples

      iex> list_reserved_stocks()
      [%ReservedStock{}, ...]

  """
  def list_reserved_stocks do
    Repo.all(ReservedStock)
  end

  @doc """
  Gets a single reserved_stock.

  Raises `Ecto.NoResultsError` if the ReservedStock does not exist.

  ## Examples

      iex> get_reserved_stock!(123)
      %ReservedStock{}

      iex> get_reserved_stock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reserved_stock!(id), do: Repo.get!(ReservedStock, id)

  @doc """
  Creates a reserved_stock.

  ## Examples

      iex> create_reserved_stock(%{field: value})
      {:ok, %ReservedStock{}}

      iex> create_reserved_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reserved_stock(attrs \\ %{}) do
    %ReservedStock{}
    |> ReservedStock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reserved_stock.

  ## Examples

      iex> update_reserved_stock(reserved_stock, %{field: new_value})
      {:ok, %ReservedStock{}}

      iex> update_reserved_stock(reserved_stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reserved_stock(%ReservedStock{} = reserved_stock, attrs) do
    reserved_stock
    |> ReservedStock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reserved_stock.

  ## Examples

      iex> delete_reserved_stock(reserved_stock)
      {:ok, %ReservedStock{}}

      iex> delete_reserved_stock(reserved_stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reserved_stock(%ReservedStock{} = reserved_stock) do
    Repo.delete(reserved_stock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reserved_stock changes.

  ## Examples

      iex> change_reserved_stock(reserved_stock)
      %Ecto.Changeset{data: %ReservedStock{}}

  """
  def change_reserved_stock(%ReservedStock{} = reserved_stock, attrs \\ %{}) do
    ReservedStock.changeset(reserved_stock, attrs)
  end

  def notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(InBeauty.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      InBeauty.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  def notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
