defmodule InBeautyWeb.Plugs.CurrentCartIdPlug do
  import Plug.Conn

  alias InBeauty.Carts
  alias InBeauty.Carts.Cart
  alias Phoenix.Controller

  def init(_opts), do: nil

  def call(%{private: %{:plug_session => %{"current_cart_id" => cart_id}}} = conn, _opts)
      when is_binary(cart_id) do
    conn
    |> tap(&IO.inspect(&1.assigns, label: :some))
    |> tap(&IO.inspect(&1.private.plug_session, label: :some))

    cart_id
    |> Carts.get_cart()
    |> case do
      nil ->
        conn
        |> delete_session(:current_cart_id)
        |> Controller.redirect(to: conn.request_path)

      %Cart{} = cart ->
        assign(conn, :current_cart, cart)
    end
  end

  def call(%{private: %{:plug_session => %{"session_id" => session_id}}} = conn, _opts) do
    IO.inspect("i am here")

    case Carts.get_cart_by(session_id: session_id) do
      nil ->
        {:ok, cart} = Carts.create_cart(%{anon: true, session_id: session_id})

        put_cart(conn, cart)

      %Cart{} = cart ->
        put_cart(conn, cart)
    end
  end

  def call(conn, _opts),
    do:
      Controller.redirect(conn, to: conn.request_path)
      |> tap(&IO.inspect(&1.assigns, label: :somes))

  defp put_cart(conn, cart) do
    conn
    |> put_session(:current_cart_id, cart.id)
    |> assign(:current_cart, cart)
  end
end
