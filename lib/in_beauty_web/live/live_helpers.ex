defmodule InBeautyWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  alias InBeautyWeb.Router.Helpers, as: Routes

  @doc """
  Renders a component inside the `InBeautyWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal InBeautyWeb.PerfumeLive.FormComponent,
        id: @perfume.id || :new,
        action: @live_action,
        perfume: @perfume,
        return_to: Routes.perfume_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(InBeautyWeb.ModalComponent, modal_opts)
  end

  @doc """
  Renders a svg from sprite.svg file&

  ## Examples
    <%= icon_tag("cart", class: classes) %>
  """
  def icon_tag(name, opts \\ []) do
    classes = Keyword.get(opts, :class, "")

    Phoenix.HTML.Tag.content_tag :svg, [class: classes] ++ opts do
      Phoenix.HTML.Tag.tag(
        :use,
        "xlink:href": Routes.static_path(InBeautyWeb.Endpoint, "/icons/sprite.svg#" <> name)
      )
    end
  end
end
