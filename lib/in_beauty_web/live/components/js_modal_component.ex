defmodule InBeautyWeb.JsModalComponent do
  use Phoenix.Component
  use Phoenix.HTML

  import InBeautyWeb.LiveHelpers, only: [icon_tag: 2]

  alias Phoenix.LiveView.JS
  # alias InBeautyWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <div
      id={@id}
      class="
        phx-modal
        fixed
        hidden
        inset-0
        overflow-y-auto
        h-full
        w-full
        slide-bottom
        z-20
        px-2
        bg-gray-100
        dark:bg-gray-800
        bg-opacity-90      
      "
      phx-remove={hide_modal(@id)}
      phx-capture-click={hide_modal(@id)}
      phx-window-keydown={hide_modal(@id)}
      phx-key="escape"
      phx-page-loading
      >      
      <div>        
        <div class="flex items-center">      
          <a class=" w-12 h-12 dark:text-gray-100 ml-4 cursor-pointer" phx-click={hide_modal(@id)}>            
            <%= icon_tag("arrow-left", class: "w-12 h-12 inline-block") %>     
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
    |> JS.hide(to: "#" <> id)
    |> JS.remove_class("overflow-hidden", to: "#body")
  end
end
