defmodule InBeautyWeb.JsModalComponent do
  use Phoenix.Component
  use Phoenix.HTML
  alias Phoenix.LiveView.JS
  alias InBeautyWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <div
      id={@id}     
      class="
        phx-modal
        flex
        flex-col
        slide-bottom
        fixed
        min-w-screen
        h-full
        inset-0
        overflow-auto
        z-20
        px-2
        bg-gray-300
        dark:bg-gray-800
        backdrop-filter
        backdrop-blur-md
        firefox:bg-opacity-30
        
      "
      phx-remove={hide_modal(@id)}
      phx-capture-click={hide_modal(@id)}
      phx-window-keydown={hide_modal(@id)}
      phx-key="escape"
      phx-page-loading
      >    
      <img class="inset-0 fixed w-screen h-screen -z-10 object-cover" src={Routes.static_path(InBeautyWeb.Endpoint, "/images/fluid.svg")} alt="product-image">      
      <div>        
        <div class="flex items-center">      
          <a class="w-12 h-12 dark:text-gray-100 ml-4 cursor-pointer" phx-click={hide_modal(@id)}>
            <%= InBeautyWeb.IconView.render("arrow-left.html") %>
          </a>
          <p class="ml-4 text-2xl md:text-3xl text-midnight-500 dark:text-gray-100 font-bold">
          <%= @label %>
          </p>
        </div>

        <%= render_slot(@inner_block) %>      
      </div>      
    </div>
    """
  end

  defp hide_modal(id, js \\ %JS{}) do
    js
    |> JS.toggle(to: "#" <> id, display: "flex", time: 100)

    # |> JS.hide(transition: "fade-out", to: "#" <> id, time: 100)    
    # |> JS.hide(transition: "fade-out-scale", to: "#modal-content")
  end
end
