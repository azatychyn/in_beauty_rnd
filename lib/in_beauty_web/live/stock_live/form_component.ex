defmodule InBeautyWeb.StockLive.FormComponent do
  use InBeautyWeb, :live_component

  alias InBeauty.Stocks

  @impl true
  def update(%{stock: stock} = assigns, socket) do
    changeset = Stocks.change_stock(stock)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"stock" => stock_params}, socket) do
    changeset =
      socket.assigns.stock
      |> Stocks.change_stock(stock_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"stock" => stock_params}, socket) do
    save_stock(socket, socket.assigns.action, stock_params)
  end

  defp save_stock(socket, :edit, stock_params) do
    case Stocks.update_stock(socket.assigns.stock, stock_params) do
      {:ok, _stock} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stock updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_stock(socket, :new, stock_params) do
    case Stocks.create_stock(stock_params) do
      {:ok, _stock} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stock created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
