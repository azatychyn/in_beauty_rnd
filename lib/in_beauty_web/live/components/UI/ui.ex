defmodule InBeautyWeb.UI do
  use Phoenix.Component
  use Phoenix.HTML

  def select(assigns) do
    ~H"""
      <select id={@field} name={@field} class={"#{@wrapper_size} block border-2 border-rose-300 rounded-2xl appearance-none bg-transparent text-xl p-8 md:p-10"}>
        <%= for variant <- @variants do %>
          <option value={variant} selected={variant == "#{@selected_variant}"} >
            <%= variant %>
          </option>
        <% end %>
      </select>    
    """
  end
end
