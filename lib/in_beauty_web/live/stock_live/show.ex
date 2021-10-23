defmodule InBeautyWeb.StockLive.Show do
  use InBeautyWeb, :live_view

  alias InBeauty.Stocks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:stock, Stocks.get_stock!(id))}
  end

  defp page_title(:show), do: "Show Stock"
  defp page_title(:edit), do: "Edit Stock"
end
