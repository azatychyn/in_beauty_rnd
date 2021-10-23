defmodule InBeautyWeb.PerfumeLive.Show do
  use InBeautyWeb, :live_view

  alias InBeauty.Catalogue

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:perfume, Catalogue.get_perfume!(id))}
  end

  defp page_title(:show), do: "Show Perfume"
  defp page_title(:edit), do: "Edit Perfume"
end
