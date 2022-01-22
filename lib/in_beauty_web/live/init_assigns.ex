defmodule InBeautyWeb.InitAssigns do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView
  import Plug.Conn, only: [delete_session: 2, put_session: 3]

  alias Phoenix.Controller

  alias InBeauty.Carts
  alias InBeauty.Carts.Cart

  def on_mount(:default, _params, session, socket) do
    IO.inspect(socket.assigns, label: "i am in default init assign")
    IO.inspect(session, label: "session i am in default init assign")

    if connected?(socket) do
      cart_validation(socket, session)
    else
      {:cont, assign(socket, :current_cart, nil)}
    end
  end

  def on_mount(:admin, _params, _session, socket) do
    socket =
      socket
      |> put_flash(:error, "You're not authorized to do that!")
      |> redirect(to: "/")

    {:halt, socket}
  end

  defp cart_validation(socket, %{"session_id" => session_id}) do
    case Carts.get_cart_by(session_id: session_id) do
      nil ->
        {:ok, cart} = Carts.create_cart(%{anon: true, session_id: session_id})
        {:cont, assign(socket, :current_cart, cart)}

      %Cart{} = cart ->
        {:cont, assign(socket, :current_cart, cart)}
    end
  end
end
