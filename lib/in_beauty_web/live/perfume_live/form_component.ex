defmodule InBeautyWeb.PerfumeLive.FormComponent do
  use InBeautyWeb, :live_component

  alias InBeauty.Catalogue

  @impl true
  def update(%{perfume: perfume} = assigns, socket) do
    changeset = Catalogue.change_perfume(perfume)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"perfume" => perfume_params}, socket) do
    changeset =
      socket.assigns.perfume
      |> Catalogue.change_perfume(perfume_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"perfume" => perfume_params}, socket) do
    save_perfume(socket, socket.assigns.action, perfume_params)
  end

  defp save_perfume(socket, :edit, perfume_params) do
    case Catalogue.update_perfume(socket.assigns.perfume, perfume_params) do
      {:ok, _perfume} ->
        {:noreply,
         socket
         |> put_flash(:info, "Perfume updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_perfume(socket, :new, perfume_params) do
    case Catalogue.create_perfume(perfume_params) do
      {:ok, _perfume} ->
        {:noreply,
         socket
         |> put_flash(:info, "Perfume created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
