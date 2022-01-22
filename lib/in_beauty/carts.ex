defmodule InBeauty.Carts do
  import Ecto.Query
  alias InBeauty.Carts.Cart
  alias InBeauty.Repo

  @topic inspect(__MODULE__)

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  @spec list_carts() :: [Cart.t(), ...]
  def list_carts, do: Repo.all(Cart)

  @doc """
  Returns the list of carts with filtering and pagination.

  ## Examples

      iex> list_carts(%{role: ["admin"], })
      %%Scrivener.Page{entries: [%Cart{}, ...], page_number: _, page_size: _, total_entries: _, total_pages: _}

  """
  @spec list_carts(map()) :: Scrivener.Page.t()
  def list_carts(params) when is_map(params) do
    Cart
    |> filter_roles(params)
    |> sort(params)
    |> Repo.paginate(params)
  end

  @doc """
  Returns the list of products with filtering and pagination.

  ## Examples

      iex> count_products(%{gender: [male], })
      %%Scrivener.Page{entries: [%Produc{}, ...], page_number: _, page_size: _, total_entries: _, total_pages: _}

  """
  @spec count_carts(map()) :: non_neg_integer
  def count_carts(params) when is_map(params) do
    Cart
    |> filter_roles(params)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single cart by params.

  ## Examples

      iex> get_cart([field: value])
      %Cart{}

      iex> get_cart([field: bad_value])
      nil

  """
  @spec get_cart_by(Keyword.t() | map()) :: Cart.t() | nil
  def get_cart_by(params), do: Repo.get_by(Cart, params)

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_cart!(String.t()) :: Cart.t() | Ecto.NoResultsError.t()
  def get_cart!(id), do: Repo.get!(Cart, id)

  @doc """
  Gets a single cart.

  Return nil if the Cart does not exist.

  ## Examples

      iex> get_cart(123)
      %Cart{}

      iex> get_cart(456)
      nil

  """
  @spec get_cart(String.t()) :: Cart.t() | nil
  def get_cart(id), do: Repo.get(Cart, id)

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_cart(map()) :: {:ok, Cart.t()} | {:error, Ecto.Changeset.t()}
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:cart, :created])
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_cart(Cart.t(), map()) :: {:ok, Cart.t()} | {:error, Ecto.Changeset.t()}
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
    |> notify_subscribers([:cart, :updated])
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_cart(Cart.t()) :: {:ok, Cart.t()} | {:error, Ecto.Changeset.t()}
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
    |> notify_subscribers([:cart, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """
  @spec change_cart(Cart.t(), map()) :: Ecto.Changeset.t()
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  @doc """
  Returns a Cart with generated product count and total price.

  ## Examples

      iex> add_cart_attrs(cart)
      %Cart{}
  """
  @spec add_cart_attrs(Cart.t()) :: Cart.t()
  def add_cart_attrs(cart), do: add_cart_attrs(cart.stocks_carts, cart, {0, 0})

  # defp add_cart_attrs(stocks_carts, cart, acc)

  defp add_cart_attrs([], cart, {product_count, total_price}) do
    %Cart{cart | total_price: total_price, product_count: product_count}
  end

  defp add_cart_attrs([stock_cart | tail], cart, {cart_count, total_price}) do
    acc =
      {stock_cart.quantity + cart_count,
       stock_cart.stock.price * stock_cart.quantity + total_price}

    add_cart_attrs(tail, cart, acc)
  end

  defp filter_roles(query, %{roles: ["user", ""]}) do
    where(query, [q], q.anon == false)
  end

  defp filter_roles(query, %{roles: ["anon", ""]}) do
    where(query, [q], q.anon == true)
  end

  defp filter_roles(query, _) do
    query
  end

  defp sort(query, %{sort: %{sort_by: sort_by, sort_order: sort_order}}) do
    order_by(query, [{^sort_order, ^sort_by}])
  end

  defp sort(query, _) do
    query
  end

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
end
