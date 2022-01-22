defmodule InBeautyWeb.PerfumeLive.Image do
  use InBeautyWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <div class="w-screen h-screen bg-white ">
      <img class="w-full h-full rounded-2xl object-contain mx-auto" src="<%= @image_path %>" alt="Nike Air">
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(%{"path" => path}, _url, socket) do
    socket =
      socket
      |> assign(:page_title, "Image - #{path}")
      |> assign(:image_path, path)

    {:noreply, socket}
  end
end
