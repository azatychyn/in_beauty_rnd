defmodule InBeautyWeb.PerfumeLive.Index do
  use InBeautyWeb, :live_view

  import InBeautyWeb.LiveHelpers, only: [icon_tag: 2]

  alias InBeauty.Catalogue
  alias InBeauty.Stocks
  alias Phoenix.LiveView.JS

  @genders_variants ["men", "women", "unisex"]
  @pages_variants ["20", "40"]
  @default_page_size 5
  @volumes_variants ["30", "40", "50", "100", "200", "300", "400"]
  @manufacturers_variants ["some manufactorer"]
  @default_pages List.duplicate([], 10)

  @impl true
  def mount(params, _session, socket) do
    filter_options = filter_options(params)

    if connected?(socket) do
      Process.send_after(self(), {:get_init_perfumes, filter_options}, 500)
      send(self(), :get_manufacturers)
      send(self(), :get_volumes)
    end

    socket =
      socket
      |> assign(:perfumes_count, 0)
      |> assign(:volumes_variants, @volumes_variants)
      |> assign(:genders_variants, @genders_variants)
      |> assign(:manufacturers_variants, @manufacturers_variants)
      |> assign(:pages_variants, @pages_variants)
      |> assign(:page_title, "Listing Perfumess")
      |> assign(:return_path, :perfume_index_path)
      |> assign(:pages, @default_pages)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(:filter_options, filter_options(params))
      |> apply_action(socket.assigns.live_action, [])

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    if connected?(socket) do
      Process.send_after(self(), {:get_perfumes, socket.assigns.filter_options}, 0)
    end

    update(socket, :pages, fn prev_pages -> prev_pages ++ [[]] end)
  end

  @impl Phoenix.LiveView
  def handle_info({:get_init_perfumes, filter_options}, socket) do
    pages =
      if filter_options.page not in [1, "1", nil] do
        filter_options
        |> Map.put(:page, 1)
        |> Map.put(:page_size, filter_options.page_size * (filter_options.page - 1))
        |> Catalogue.list_perfumes()
        |> Map.get(:entries)
        |> Enum.chunk_every(filter_options.page_size)
      else
        []
      end

    socket = update(socket, :pages, fn prev_pages -> pages ++ (prev_pages -- @default_pages) end)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:get_perfumes, filter_options}, socket) do
    pages = Catalogue.list_perfumes(filter_options)

    socket =
      socket
      |> assign(:total_pages, pages.total_pages)
      |> update(:pages, fn prev_pages -> List.replace_at(prev_pages, -1, pages.entries) end)
      |> assign(:perfumes_count, pages.total_pages * pages.page_size)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:get_manufacturers, socket) do
    manufacturers = Catalogue.list_manufacturers()
    {:noreply, assign(socket, :manufacturers_variants, manufacturers)}
  end

  @impl Phoenix.LiveView
  def handle_info(:get_volumes, socket) do
    volumes = Enum.map(Stocks.list_volumes(), &to_string/1)

    {:noreply, assign(socket, :volumes_variants, volumes)}
  end

  @impl Phoenix.LiveView
  def handle_event("sort", %{"page_size" => page_size}, socket) do
    page_size = String.to_integer(page_size) |> ceil()
    filter_options = socket.assigns.filter_options
    page = Float.ceil(filter_options.page_size * filter_options.page / page_size) |> ceil()

    filter_options =
      filter_options
      |> Map.put(:page_size, page_size)
      |> Map.put(:page, page)

    socket = push_redirect(socket, to: Routes.perfume_index_path(socket, :index, filter_options))
    {:noreply, socket}
  end

  def handle_event("remove_filter", %{"filter_group" => filter_group, "filter" => filter}, socket) do
    filter_group = String.to_existing_atom(filter_group)

    filter_options =
      update_in(socket.assigns.filter_options, [filter_group], &List.delete(&1, filter))

    socket = push_redirect(socket, to: Routes.perfume_index_path(socket, :index, filter_options))

    {:noreply, socket}
  end

  defp filter_options(params) do
    %{
      page: check_page(params["page"]),
      page_size: check_page_size(params["page_size"]),
      genders: params["genders"] || [],
      volumes: params["volumes"] || [],
      manufacturers: params["manufacturers"] || [],
      price: params["price"] || ["0", "10000"]
    }
  end

  defp all_selected_filters(filter_options) do
    filter_options
    |> Map.take([:volumes, :manufacturers, :genders])
    |> Enum.reduce([], fn {filter_group, filters}, acc ->
      filters
      |> Stream.filter(&(&1 != ""))
      |> Enum.map(fn filter -> {filter_group, filter} end)
      |> then(&(&1 ++ acc))
    end)
  end

  defp load_more?(current_page, total_pages), do: current_page < total_pages

  defp show_modal(id, js \\ %JS{}) do
    js
    |> JS.show(transition: "fade-out", to: "#" <> id)
    |> JS.show(transition: "fade-out-scale", to: "#modal-content")
    |> JS.add_class("overflow-hidden", to: "#body")
  end

  defp check_page(nil), do: 1

  defp check_page(page), do: page |> String.to_integer() |> page_guard()

  defp check_page_size(nil), do: @default_page_size

  defp check_page_size(page_size),
    do: page_size |> String.to_integer() |> page_size_guard()

  defp page_guard(page) when page <= 0, do: 1

  defp page_guard(page), do: page

  defp page_size_guard(page_size) when page_size >= 100, do: 100

  defp page_size_guard(page_size) when page_size > 5, do: page_size

  defp page_size_guard(_), do: @default_page_size

  defp filter_options_map(filter_options) do
    InBeauty.Catalogue.Filter
    |> struct(filter_options)
    |> Map.take(InBeauty.Catalogue.Filter.__schema__(:fields))
  end
end
