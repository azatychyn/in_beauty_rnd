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
  @volumes_variants ["30", "40", "50", "100", "200"]

  @impl true
  def mount(params, _session, socket) do
    filter_options = filter_options(params)

    if connected?(socket) do
      Process.send_after(self(), {:get_init_perfumes, filter_options}, 500)
      send(self(), :get_manufacturers)
      send(self(), :get_volumes)
    end

    pages = initial_pages(filter_options)

    socket =
      socket
      |> assign(:volumes_variants, @volumes_variants)
      |> assign(:genders_variants, @genders_variants)
      |> assign(:manufacturers_variants, [])
      |> assign(:pages_variants, @pages_variants)
      |> assign(:page_title, "Listing Perfumess")
      |> assign(:return_path, :perfume_index_path)
      |> assign(:max_page, 0)
      |> assign(:loaded_pages, [0])
      |> assign(:total_pages, 0)
      |> assign(:pages, pages)

    {:ok, socket}
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
    page = socket.assigns.filter_options.page
    page_size = socket.assigns.filter_options.page_size
    IO.inspect("i am in index applu action")

    if connected?(socket) do
      Process.send_after(self(), {:get_perfumes, socket.assigns.filter_options}, 0)
    end

    perfumes = Enum.map(1..page_size, &%{id: "#{page}-#{&1}"})
    max_page = max(socket.assigns.max_page, page)
    key = :"page_#{page}"
    value = %{loading?: true, perfumes: perfumes}

    socket
    |> update(:pages, fn prev_pages -> Map.put(prev_pages, key, value) end)
    |> assign(:max_page, max_page)
  end

  @impl Phoenix.LiveView
  def handle_info({:get_init_perfumes, filter_options}, socket) do
    pages =
      filter_options
      |> Map.put(:page, 1)
      |> Map.put(:page_size, filter_options.page_size * (filter_options.page - 1))
      |> Catalogue.list_perfumes()
      |> Map.get(:entries)
      |> Stream.chunk_every(filter_options.page_size)
      |> Stream.with_index(1)
      |> Enum.reduce(socket.assigns.pages, fn {entries, index}, acc ->
        Map.put(acc, :"page_#{index}", %{loading?: false, perfumes: entries})
      end)

    socket =
      socket
      |> assign(:pages, pages)
      |> assign(:perfume_loading, false)
      |> assign(:loaded_pages, Enum.to_list(1..(filter_options.page - 1)))

    IO.inspect("i am in handle init perfumes")
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:get_perfumes, filter_options}, socket) do
    perfumes = Catalogue.list_perfumes(filter_options)
    page_number = perfumes.page_number
    key = :"page_#{page_number}"
    value = %{loading?: false, perfumes: perfumes.entries}
    pages = Map.put(socket.assigns.pages, key, value)

    socket =
      socket
      |> assign(:total_pages, perfumes.total_pages)
      |> update(:pages, fn prev_pages -> Map.put(prev_pages, key, value) end)
      |> update(:loaded_pages, fn loaded_pages -> [page_number | loaded_pages] end)

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
      filters
      |> Stream.filter(&(&1 != ""))
      |> Enum.map(fn filter -> {filter_group, filter} end)
      |> then(&[&1 | acc])
    end)
  end

  defp initial_pages(filter_options) do
    Map.new(1..filter_options.page, fn i ->
      {:"page_#{i}", %{loading?: true, perfumes: []}}
    end)
  end

  defp load_more?(current_page, total_pages), do: current_page < total_pages
end
