defmodule InBeautyWeb.PerfumeLive.Index do
  use InBeautyWeb, :live_view
  import Ecto.Query, only: [from: 2]
  alias InBeauty.Catalogue
  alias InBeauty.Catalogue.Perfume
  alias InBeauty.Stocks

  alias InBeauty.Repo

  @genders_variants ["men", "women", "unisex"]
  @pages_variants ["20", "40"]
  @default_page_size "20"

  @impl true
  def mount(params, _session, socket) do
    IO.inspect("i am in mount of index perfume")
    filter_options = filter_options(params)

    if connected?(socket) do
      Process.send_after(self(), {:get_init_products, filter_options}, 500)
      send(self(), :get_manufacturers)
      send(self(), :get_volumes)
    end

    pages =
      1..(filter_options.page_size * (filter_options.page - 1))
      |> Enum.to_list()
      |> Enum.map(&%{id: "#{filter_options.page - 1}-#{&1}"})
      |> Enum.chunk_every(filter_options.page_size)
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {entries, index}, acc ->
        Map.put(acc, :"page_#{index}", %{loading?: true, products: entries})
      end)

    volumes_variants = ["30", "40", "50", "100", "200"]

    socket =
      socket
      |> assign(:volumes_variants, volumes_variants)
      |> assign(:genders_variants, @genders_variants)
      |> assign(:manufacturers_variants, [])
      |> assign(:pages_variants, @pages_variants)
      |> assign(:page_title, "Listing Perfumess")
      |> assign(:return_path, :product_index_path)
      |> assign(:max_page, 0)
      |> assign(:loaded_pages, [0])
      |> assign(:total_pages, 0)
      |> assign(:pages, pages)

    {:ok, assign(socket, :perfumes, list_perfumes())}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Perfume")
    |> assign(:perfume, Catalogue.get_perfume!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Perfume")
    |> assign(:perfume, %Perfume{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Perfumes")
    |> assign(:perfume, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    perfume = Catalogue.get_perfume!(id)
    {:ok, _} = Catalogue.delete_perfume(perfume)

    {:noreply, assign(socket, :perfumes, list_perfumes())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(:filter_options, filter_options(params))
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, params) do
    if connected?(socket) do
      Process.send_after(self(), {:get_products, socket.assigns.filter_options}, 0)
    end

    products =
      1..socket.assigns.filter_options.page_size
      |> Enum.to_list()
      |> Enum.map(&%{id: "#{socket.assigns.filter_options.page}-#{&1}"})

    max_page = max(socket.assigns.max_page, socket.assigns.filter_options.page)

    pages =
      Map.put(socket.assigns.pages, :"page_#{socket.assigns.filter_options.page}", %{
        loading?: true,
        products: products
      })

    socket
    |> assign(:pages, pages)
    |> assign(:max_page, max_page)
  end

  @impl Phoenix.LiveView
  def handle_info({:get_init_products, filter_options}, socket) do
    products =
      filter_options
      |> Map.put(:page, 1)
      |> Map.put(:page_size, filter_options.page_size * (filter_options.page - 1))
      |> Catalogue.list_perfumes()
      |> IO.inspect()

    pages =
      products.entries
      |> Enum.chunk_every(filter_options.page_size)
      |> Enum.with_index(1)
      |> Enum.reduce(socket.assigns.pages, fn {entries, index}, acc ->
        Map.put(acc, :"page_#{index}", %{loading?: false, products: entries})
      end)
      |> IO.inspect()

    socket =
      socket
      |> assign(:pages, pages)
      |> assign(:product_loading, false)
      |> assign(:loaded_pages, Enum.to_list(1..(filter_options.page - 1)))

    IO.inspect("i am in handle ")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:get_products, filter_options}, socket) do
    products = Catalogue.list_perfumes(filter_options)

    pages =
      Map.put(socket.assigns.pages, :"page_#{products.page_number}", %{
        loading?: false,
        products: products.entries
      })

    socket =
      socket
      |> assign(:pages, pages)
      |> assign(:total_pages, products.total_pages)
      |> update(:loaded_pages, fn loaded_pages -> [products.page_number | loaded_pages] end)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:get_manufacturers, socket) do
    manufacturers = Catalogue.list_manufacturers()
    {:noreply, assign(socket, :manufacturers_variants, manufacturers)}
  end

  @impl Phoenix.LiveView
  def handle_info(:get_volumes, socket) do
    volumes =
      Stocks.list_volumes()
      |> Enum.map(&to_string/1)

    {:noreply, assign(socket, :volumes_variants, volumes)}
  end

  defp list_perfumes do
    Catalogue.list_perfumes()
  end

  defp filter_options(params) do
    %{
      page: String.to_integer(params["page"] || "1"),
      page_size: String.to_integer(params["page_size"] || @default_page_size),
      genders: params["genders"] || [],
      volumes: params["volumes"] || [],
      manufacturers: params["manufacturers"] || [],
      price: params["price"] || ["0", "10000"]
    }
  end

  defp all_selected_filters(filter_options) do
    filter_options
    |> Map.take([:volumes, :manufactureers, :genders])
    |> Enum.reduce([], fn {filter_group, filters}, acc ->
      filters_tuple =
        filters
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(fn filter -> {filter_group, filter} end)

      filters_tuple ++ acc
    end)
  end

  defp load_more?(current_page, total_pages) do
    current_page < total_pages
  end
end
