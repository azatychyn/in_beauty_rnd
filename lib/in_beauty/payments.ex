defmodule InBeauty.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias InBeauty.Repo
  alias InBeauty.Payments.Order

  @topic inspect(__MODULE__)

  def subscribe, do: Phoenix.PubSub.subscribe(InBeauty.PubSub, @topic)

  def subscribe(order_id), do: Phoenix.PubSub.subscribe(InBeauty.PubSub, @topic <> "#{order_id}")

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  @spec list_orders() :: [Order.t(), ...]
  def list_orders, do: Repo.all(Order)

  @doc """
  Returns the list of orders with filtering and pagination.

  ## Examples

      iex> list_orders(%{role: ["admin"]})
      %%Scrivener.Page{entries: [%Order{}, ...], page_number: _, page_size: _, total_entries: _, total_pages: _}

  """
  @spec list_orders(map()) :: Scrivener.Page.t()
  def list_orders(params) when is_map(params) do
    Order
    |> filter_total_price(params)
    |> filter_status(params)
    |> filter_paid(params)
    |> sort(params)
    |> Repo.paginate(params)
  end

  @doc """
  Returns the list of products with filtering and pagination.

  ## Examples

      iex> count_products(%{gender: [male], })
      %%Scrivener.Page{entries: [%Produc{}, ...], page_number: _, page_size: _, total_entries: _, total_pages: _}

  """
  @spec count_orders(map()) :: non_neg_integer
  def count_orders(params) when is_map(params) do
    Order
    |> filter_total_price(params)
    |> filter_status(params)
    |> filter_paid(params)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single order by params.

  ## Examples

      iex> get_order([field: value])
      %Order{}

      iex> get_order([field: bad_value])
      nil

  """
  @spec get_order_by(Keyword.t() | map()) :: Order.t() | nil
  def get_order_by(params), do: Repo.get_by(Order, params)

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_order!(String.t()) :: Order.t() | Ecto.NoResultsError.t()
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  @spec create_order(Order.t()) :: {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  def create_order(%Order{} = order), do: create_order(order, %{})
  @spec create_order(map()) :: {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  def create_order(attrs), do: create_order(%Order{}, attrs)
  @spec create_order(Order.t(), map()) :: {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  def create_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:order, :created])
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_order(Order.t(), map()) :: {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
    |> notify_subscribers([:order, :updated])
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_order(Order.t()) :: {:ok, Order.t()} | {:error, Ecto.Changeset.t()}
  def delete_order(%Order{} = order) do
    order
    |> Repo.delete()
    |> notify_subscribers([:order, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  @spec change_order(Cart.t(), map()) :: Ecto.Changeset.t()
  def change_order(order, attrs \\ %{}), do: Order.changeset(order, attrs)

  # def add_order_attrs(stocks_orders, order, acc \\ 0)

  # def add_order_attrs([], order, total_price) do
  #   %Order{order | total_price: total_price}
  # end

  # def add_order_attrs([stock_order | tail], order, total_price) do
  #   acc = stock_order.stock.price * stock_order.quantity + total_price
  #   add_order_attrs(tail, order, acc)
  # end

  defp filter_total_price(query, %{total_price: [min, max]}) do
    min = string_to_number(min)
    max = string_to_number(max)

    where(query, [q], q.total_price >= ^min and q.total_price <= ^max)
  end

  defp filter_total_price(query, _), do: query

  defp filter_status(query, %{statuses: statuses}), do: where(query, [q], q.status in ^statuses)
  defp filter_status(query, _), do: query
  defp filter_paid(query, %{paid: paid}), do: where(query, [q], q.paid == ^paid)
  defp filter_paid(query, _), do: query

  defp sort(query, %{sort: %{sort_by: sort_by, sort_order: sort_order}}),
    do: order_by(query, [{^sort_order, ^sort_by}])

  defp sort(query, _), do: query

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(InBeauty.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      InBeauty.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}

  defp string_to_number(n), do: n |> Float.parse() |> elem(0)
end
