defmodule InBeautyWeb.Perfume.UI do
  use Phoenix.Component
  use Phoenix.HTML
  import InBeautyWeb.Gettext, only: [gettext: 1]
  import InBeautyWeb.LiveHelpers, only: [icon_tag: 2]
  alias Phoenix.LiveView.JS
  alias InBeauty.Relations.StockCart

  def perfume_information_desktop(assigns) do
    ~H"""
    <div class={"flex flex-col w-full xl:mt-8 bg-rose-50 dark:bg-midnight-500 rounded-2xl bg-rose-200 " <> " " <> @classes }>
      <p class="sm:text-lg font-semibold uppercase col-span-full rounded-t-2xl py-2 px-2 xl:px-4">
        <%= Gettext.with_locale(@locale, fn -> gettext("detailed characteristics") end) %>
      </p>
      <ul class="place-content-start h-full grid grid-cols-3 bg-rose-100 py-4 px-4 rounded-2xl text-sm xs:text-lg">
        <li>
          <%= Gettext.with_locale(@locale, fn -> gettext("for who") end) %>
        </li>
        <li class="col-span-2">
          <%= @perfume.gender %>
        </li>
        <li>
          <%= Gettext.with_locale(@locale, fn -> gettext("manufacturer") end) %>
        </li>
        <li class="col-span-2">
          <%= @perfume.manufacturer %>
        </li>
        <li>
          <%= Gettext.with_locale(@locale, fn -> gettext("hight level") end) %>
        </li>
        <li class="col-span-2">
            <%= @perfume.manufacturer %>
        </li>
        <li>
          <%= Gettext.with_locale(@locale, fn -> gettext("middle level") end) %>
        </li>
        <li class="col-span-2">
           <%= @perfume.manufacturer %>
        </li>
        <li>
          <%= Gettext.with_locale(@locale, fn -> gettext("base level") end) %>
        </li>
        <li class="col-span-2">
          <%= @perfume.manufacturer %>
        </li>
      </ul>
    </div>
    """
  end

  def perfume_description_desktop(assigns) do
    ~H"""
    <div class={"w-full max-w-2xl xl:max-w-full mx-auto xl:mx-0 bg-rose-50 dark:bg-midnight-500 rounded-2xl bg-rose-200" <> " " <> @classes}>
     <p class="font-semibold uppercase rounded-t-2xl py-2 px-2 xl:px-4 xs:text-lg md:text-2xl">
        <%= Gettext.with_locale(@locale, fn -> gettext("description") end) %>
      </p>

      <p class="p-6 2xl:p-8 bg-rose-100 rounded-2xl h-full"><%= @perfume.description %> </p>
    </div>
    """
  end

  #  def perfume_info_desktop(assigns) do
  #    ~H"""
  #    <div
  #      class="hidden lg:grid grid-cols-3 gap-4 max-w-screen-2xl mx-auto mt-8"
  #      >
  #      <ul class="dark:text-rose-100">
  #        <li
  #          id="description-tab"
  #          class="col-span-1 row-span-1 bg-rose-100 dark:bg-midnight-500 mb-4 rounded-2xl"
  #          phx-click={select_tab("description", "info")}
  #          >
  #          <input type="radio" id="perfume-description-tab" name="perfume-product-tab" value="description" class="hidden" checked>
  #          <label for="perfume-description-tab"
  #            class="block p-20 text-3xl font-extrabold xl:text-3xl text-main-pink dark:text-rose-100 capitalize text-center label-checked:bg-rose-300 dark:label-checked:bg-rose-100 rounded-2xl dark:label-checked:text-main-pink"
  #          >
  #            <%= Gettext.with_locale(@locale, fn -> gettext("description") end) %>
  #          </label>
  #        </li>
  #        <li
  #          id="info-tab"
  #          class="col-span-1 row-span-1 bg-rose-100 dark:bg-midnight-500 rounded-2xl "
  #          phx-click={select_tab("info", "description")}
  #
  #          >
  #          <input type="radio" id="perfume-info-tab" name="perfume-product-tab" value="info" class="hidden">
  #          <label for="perfume-info-tab"
  #            class="block p-20 text-3xl font-extrabold xl:text-3xl text-main-pink dark:text-rose-100 capitalize text-center label-checked:bg-rose-300 dark:label-checked:bg-rose-100 rounded-2xl dark:label-checked:text-main-pink"
  #          >
  #            <%= Gettext.with_locale(@locale, fn -> gettext("info") end) %>
  #          </label>
  #        </li>
  #     </ul>
  #      <div class="col-span-2">
  #        <div
  #          class="hidden p-6 2xl:p-8 bg-rose-50 dark:bg-midnight-500 rounded-2xl"
  #          id="info"
  #        >
  #          <p class="text-2xl mb-4">
  #            <%= Gettext.with_locale(@locale, fn -> gettext("detailed characteristics") end) %>
  #          </p>
  #          <ul class="grid grid-cols-2 text-lg">
  #            <li>
  #              <%= Gettext.with_locale(@locale, fn -> gettext("for who") end) %>
  #            </li>
  #            <li>
  #              <%= @perfume.gender %>
  #            </li>
  #            <li>
  #              <%= Gettext.with_locale(@locale, fn -> gettext("manufacturer") end) %>
  #            </li>
  #            <li>
  #              <%= @perfume.manufacturer %>
  #            </li>
  #            <li>
  #              <%= Gettext.with_locale(@locale, fn -> gettext("hight level") end) %>
  #            </li>
  #            <li>
  #              <%= @perfume.manufacturer %>
  #            </li>
  #            <li>
  #              <%= Gettext.with_locale(@locale, fn -> gettext("middle level") end) %>
  #            </li>
  #            <li>
  #              <%= @perfume.manufacturer %>
  #            </li>
  #            <li>
  #              <%= Gettext.with_locale(@locale, fn -> gettext("base level") end) %>
  #            </li>
  #            <li>
  #              <%= @perfume.manufacturer %>
  #            </li>
  #          </ul>
  #        </div>
  #        <div
  #          class="p-6 2xl:p-8 bg-rose-50 dark:bg-midnight-500 rounded-2xl"
  #          id="description"
  #        >
  #          <p class="text-2xl mb-4"> <%= @perfume.name %></p>
  #          <p><%= @perfume.description %> </p>
  #        </div>
  #      </div>
  #    </div>
  #    """
  #  end
  #
  def perfume_info_mobile(assigns) do
    ~H"""
    <ul class="block lg:hidden my-4 xs:my-8 dark:text-rose-100 px-2 mx-auto h-full">
     <li class="bg-rose-100 dark:bg-midnight-500 rounded-2xl p-3 xs:p-6 mb-4">
        <div>
          <p class="text-2xl mb-4 capitalize">
            <%= Gettext.with_locale(@locale, fn -> gettext("detailed characteristics") end) %>
          </p>
          <ul class="grid grid-cols-2 text-lg">
            <li>
              <%= Gettext.with_locale(@locale, fn -> gettext("for who") end) %>
            </li>
            <li><%= @perfume.gender %></li>
            <li>
              <%= Gettext.with_locale(@locale, fn -> gettext("manufacturer") end) %>
            </li>
            <li><%= @perfume.manufacturer %></li>
            <li>
              <%= Gettext.with_locale(@locale, fn -> gettext("hight level") end) %>
            </li>
            <li><%= @perfume.manufacturer %></li>
            <li>
              <%= Gettext.with_locale(@locale, fn -> gettext("middle level") end) %>
            </li>
            <li><%= @perfume.manufacturer %></li>
            <li>
              <%= Gettext.with_locale(@locale, fn -> gettext("base level") end) %>
            </li>
            <li><%= @perfume.manufacturer %></li>
          </ul>
        </div>
      </li>
      <li class="bg-rose-100 dark:bg-midnight-500 rounded-2xl p-3 xs:p-6">
        <p class="text-xl mb-4"> <%= @perfume.name %></p>
        <p><%= @perfume.description %> </p>
      </li>
    </ul>
    """
  end

  def stock_cart_volume(assigns) do
    ~H"""
    <ul class="bg-rose-100 py-4 rounded-2xl">
      <%= for stock <- @stocks  do %>
        <li
          phx-click="select_stock"
          phx-throttle="1000"
          phx-value-id={stock.id}
          class={"
           inline-block
           rounded-full
            w-14
            xs:w-20
            py-4
            xs:py-6
            px-4
            xs:px-4
            text-center
            text-base
            xs:text-2xl
            text-midnight-500
            mx-2
            cursor-pointer
            hover:bg-rose-100
            relative
            hover:bg-rose-300
            #{if @selected_stock.quantity < 1 && stock.id == @selected_stock.id, do: "text-gray-400", else: if @selected_stock.id == stock.id, do: "bg-rose-300", else: ""}"
          }
        >
          <%= stock.volume %>
        </li>
      <% end %>
    </ul>
    """
  end

  def favorite_button(assigns) do
    ~H"""
    <button
      class="ml-4 xs:ml-6 rounded-2xl p-4 bg-rose-100"
      phx-click="remove_from_favorite"
      phx-throttle="1000"
      >
      <%= icon_tag("heart", class: "h-8 w-8 text-rose-500") %>
    </button>
    """
  end

  def unfavorite_button(assigns) do
    ~H"""
    <button
      class="group bg-rose-100 rounded-2xl p-4"
      phx-click="add_to_favorite"
      phx-throttle="1000"
      >
      <%= icon_tag("heart", class: "h-12 w-12 text-white group-hover:text-rose-500 mx-auto") %>
    </button>
    """
  end

  def stock_cart(assigns) do
    ~H"""
    <section class={"rounded-2xl" <> " " <> @classes} id="stocks_info">
      <div class="rounded-2xl bg-rose-200">
        <p class="text-base xs:text-lg font-semibold uppercase col-span-full rounded-t-2xl py-2 px-2 xl:px-4">
          <%= Gettext.with_locale(@locale, fn -> gettext("volume") <> " / " <> gettext("ml") end) %>
        </p>
        <InBeautyWeb.Perfume.UI.stock_cart_volume stocks={@perfume.stocks}, selected_stock={@selected_stock}/>
      </div>

      <div class="grid grid-cols-3 gap-4 mt-4 text-center" id="stocks_info">
        <div class="bg-rose-100 p-2 xs:p-4 xl:p-8 rounded-2xl">
          <p class="text-md xl:text-xl text-rose-300">
            <%= Gettext.with_locale(@locale, fn -> gettext("price") end) %>
          </p>
          <strong class="block py-2 text-lg xl:text-2xl">
            <%= @selected_stock.price %> &#8381;
          </strong>
        </div>
        <div class="bg-rose-100 p-2 xs:p-4 xl:p-8 rounded-2xl">
          <p class="text-md xl:text-xl text-rose-300">
            <%= Gettext.with_locale(@locale, fn -> gettext("in cart") end) %>
          </p>
          <strong class="block py-2 text-lg xl:text-2xl">
            <%= @stock_cart &&  @stock_cart.quantity || 0 %>
          </strong>
        </div>
        <%= if @favorite do %>
          <InBeautyWeb.Perfume.UI.favorite_button favorite: @favorite />
        <% else %>
          <InBeautyWeb.Perfume.UI.unfavorite_button favorite: @favorite />
        <% end %>

        <%= if @selected_stock.quantity > 1 do %>
          <button
            phx-click={if @stock_cart, do: "add_more", else: "add_to_cart"}
            phx-throttle="500"
            class={"px-16 py-4 xl:py-8 bg-rose-300 xl:text-lg xs:text-xl sm:text-2xl hover:text-white rounded-2xl  col-span-full uppercase font-bold
            #{if @selected_stock.quantity < 1, do: "pointer-events-none opacity-50", else: ""}
          "}
          >
            <%= add_to_cart_button_text(@stock_cart, @locale) %>
          </button>
        <% else %>
          <button
            class="px-16 py-4 xl:py-8 bg-gray-300 xl:text-lg xs:text-xl sm:text-2xl hover:text-white rounded-2xl  col-span-full uppercase font-bold
    pointer-events-none opacity-50"
          >
            <%= Gettext.with_locale(@locale, fn -> gettext("not in stock") end) %>
          </button>

        <% end %>
      </div>
    </section>
    """
  end

  def inbeauty_features(assigns) do
    ~H"""
    <ul class={"grid grid-rows-3 xl:grid-rows-1  grid-cols-1 xl:grid-cols-3 gap-4 place-items-center max-w-4xl max-h-80  mx-auto xl:mx-0" <> " " <> @classes}>
      <li class="h-24 flex items-center rounded-2xl bg-rose-100 p-4 w-full">
        <span class="pr-4">
          <%= icon_tag("truck", class: "h-12 w-12 text-rose-300") %>
        </span>
        <span>
          <%= Gettext.with_locale(@locale, fn -> gettext("free delivery from") end) %> 2000 &#8381;
        </span>
      </li>
      <li class="h-24 flex items-center rounded-2xl bg-rose-100 p-4 w-full">
        <span class="pr-4">
          <%= icon_tag("truck", class: "h-12 w-12 text-rose-300") %>
        </span>
        <span>
          <%= Gettext.with_locale(@locale, fn -> gettext("quality garantee") end) %>
        </span>
      </li>
      <li class="h-24 flex items-center rounded-2xl bg-rose-100 p-4 w-full">
        <span class="pr-4">
          <%= icon_tag("truck", class: "h-12 w-12 text-rose-300") %>
        </span>
        <span>
          <%= Gettext.with_locale(@locale, fn -> gettext("delivery to all corners of Russia") end) %>
        </span>
      </li>
    </ul>


    """
  end

  defp select_tab(id, hide_id, js \\ %JS{}) do
    js
    |> unselect_tab(hide_id)
    |> JS.show(to: "##{id}", transition: {"ease-out duration-300", "opacity-0", "opacity-100"})
  end

  defp add_to_cart_button_text(%StockCart{}, locale),
    do: Gettext.with_locale(locale, fn -> gettext("add more") end)

  defp add_to_cart_button_text(_, locale),
    do: Gettext.with_locale(locale, fn -> gettext("add to cart") end)

  defp unselect_tab(js, id), do: JS.hide(js, to: "##{id}")
end
