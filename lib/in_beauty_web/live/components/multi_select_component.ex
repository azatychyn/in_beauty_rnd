defmodule InBeautyWeb.MultiSelectComponent do
  use Phoenix.Component
  use Phoenix.HTML
  alias Phoenix.LiveView.JS

  def desktop(assigns) do
    ~H"""
    <section class="relative max-w-xs xs:max-w-full w-11/12 xs:w-auto">
      <div class="hidden md:flex relative p-1 w-max">
        <p class="w-64 text-3xl font-medium my-auto mr-12 break-all"><%= @placeholder %>:</p>
        <div class="w-80 pr-12 bg-white dark:bg-midnight-500 border-2 border-rose-300 rounded-2xl relative h-auto">
          <div class="flex items-center h-12 rounded-2xl overflow-x-auto">
            <%= if @selected_variants not in [[], [""], ""] do %>
              <%= for selected_variant <- List.delete(@selected_variants, "") do %>
                <p class="px-2 py-1 mx-1 border-2 border-rose-300 bg-rose-300 bg-gradient-to-bl dark:from-rose-200 dark:to-rose-300 dark:border-rose-300 rounded-2xl text-xl text-center whitespace-nowrap ">
                  <%= selected_variant %>
                </p>
              <% end %>
            <% else %>
              <p class="w-full px-2 py-1 mx-1 text-xl  text-center text-gray-500 dark:text-gray-400">
                Select <%= @placeholder %>
              </p>
          <% end %>
          </div>
          <div           
            phx-click={toggle_dropbown(@field)}
            phx-click-away={JS.hide(to: "#multiselect_dropdown#{@field}")}
            class="absolute bottom-1 right-1 p-2.5 h-10 w-10 ml-4"
            >
            <svg class="text-rose-300" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="4" d="M19 9l-7 7-7-7" />
            </svg>
          </div>
          <!-- DROPDOWN -->
          <div id={"multiselect_dropdown#{@field}"}
            class="absolute z-10 inset-x-0 top-14 flex flex-col bg-white dark:bg-denim-500 rounded-2xl shadow-2xl overflow-hidden"
            >
            <%= for variant <- @variants do %>
              <div class="flex items-center group hover:bg-rose-100">
                <label for={variant} class="w-full flex items-center px-4 py-2 ">
                  <input
                    type="checkbox"
                    id={variant}
                    name={"#{@field}[]"}
                    value={ variant}
                    class="
                      appearance-none
                      border
                      border-gray-300
                      rounded-md
                      group-hover:bg-rose-200
                      group-hover:border-rose-300
                      checked:bg-rose-300
                      checked:border-rose-400
                      h-6
                      w-6
                    "
                    checked={variant in @selected_variants}                    
                  >
                  <span class="w-max ml-2 text-xl text-gray-700 dark:text-gray-100 group-hover:text-gray-700">
                    <%= humanize(variant) %>
                  </span>
                </label>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </section>

    <!--  mobile  -->

    <section class="relative max-w-xs xs:max-w-full w-11/12 xs:w-auto">
      <div
        class="flex md:hidden relative p-1 w-full"
      >
        <p class="w-32 text-xl font-medium text-rose-100 my-auto mr-12 break-all"><%= @placeholder %>:</p>
        <div class="flex items-center justify-center z-10 w-40 h-16 bg-white dark:bg-midnight-500 border-2 border-rose-300 rounded-2xl relative">
          <select name={ "#{@field}[]"} multiple phx-debounce="blur" class="absolute z-10 p-2.5 h-full w-full opacity-0">
            <%= for variant <- @variants do %>
              <option
                value={variant}
                selected={variant in @selected_variants}                
              >
                <%= variant %>
              </option>
            <% end %>
          </select>
          <p class="w-full px-2 py-1 text-center text-xl text-gray-500 dark:text-gray-400 break-all">
            <%= @placeholder %>
          </p>
          <div class="absolute bottom-1 right-1 p-2.5 h-10 w-10 ml-4">
            <svg class="text-rose-100" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122" />
            </svg>
          </div>
        </div>
        <input type="hidden" name={"#{@field}[]"} value="" />
      </div>
    </section>    
    """
  end

  def mobile(assigns) do
    ~H"""
    <section class="relative max-w-xs xs:max-w-full w-11/12 xs:w-auto">
      <div
        class="flex relative p-1 w-full"
      >
        <p class="w-32 text-xl font-medium text-rose-100 my-auto mr-12 break-all"><%= @placeholder %>:</p>
        <div class="flex items-center justify-center z-10 w-40 h-16 bg-white dark:bg-midnight-500 border-2 border-rose-300 rounded-2xl relative">
          <select name={ "#{@field}[]"} multiple phx-debounce="blur" class="absolute z-10 p-2.5 h-full w-full opacity-0">
            <%= for variant <- @variants do %>
              <option
                value={variant}
                selected={variant in @selected_variants}                
              >
                <%= variant %>
              </option>
            <% end %>
          </select>
          <p class="w-full px-2 py-1 text-center text-xl text-gray-500 dark:text-gray-400 break-all">
            <%= @placeholder %>
          </p>
          <div class="absolute bottom-1 right-1 p-2.5 h-10 w-10 ml-4">
            <svg class="text-rose-100" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122" />
            </svg>
          </div>
        </div>
        <input type="hidden" name={"#{@field}[]"} value="" />
      </div>
    </section>
    """
  end

  def toggle_dropbown(field, js \\ %JS{}) do
    js
    |> JS.toggle(
      to: "#multiselect_dropdown#{field}",
      in: {"linear duration-500", "max-h-0 opacity-30", "max-h-screen opacity-100"},
      out: {"linear duration-500", "max-h-screen", "max-h-0"},
      time: 800,
      display: "flex"
    )
  end
end
