defmodule InBeautyWeb.InitAssigns do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  @genders_variants ["men", "women", "unisex"]
  @pages_variants ["20", "40"]
  @default_page_size "20"

  def on_mount(:default, params, _session, socket) do
    IO.inspect("i am in default init assign")
    {:cont, socket}
  end

  def on_mount(:admin, _params, _session, socket) do
    socket =
      socket
      |> put_flash(:error, "You're not authorized to do that!")
      |> redirect(to: "/")

    {:halt, socket}
  end
end
