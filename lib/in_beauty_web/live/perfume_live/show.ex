# defmodule InBeautyWeb.PerfumeLive.Show do
#   use InBeautyWeb, :live_view
#   # use InBeautyWeb.LocaleEventHandler

#   alias InBeauty.Catalogue
#   alias InBeauty.Relations
#   alias InBeautyWeb.Forms.PerfumeImageComponent
#   # alias InBeauty.Catalogue.{Perfume, Stock, Review}
#   # alias InBeautyWeb.Forms.PerfumeFormComponent
#   # alias InBeautyWeb.InputComponent
#   # alias InBeauty.Repo

#   @impl true
#   def mount(_params, session, socket) do    
#     socket = 
#       socket            
#       |> assign(:device, "desktop")            
#     {:ok, socket}    
#   end

#   @impl true
#   def handle_params(%{"id" => id} = params, _url, socket) do
#     perfume = Catalogue.get_perfume!(id)
#     stock = List.first(perfume.stocks)
#     # cart_id = socket.assigns.current_cart.id

#     stock_cart =
#       Relations.get_stock_cart_by(stock_id: stock.id, cart_id: cart_id, volume: stock.volume)

#     favorite = favorite_perfume?(perfume.carts_perfumes, perfume.id)

#     if connected?(socket), do: Catalogue.subscribe(perfume.id)

#     socket
#     |> assign(:page_title, "Perfume - #{perfume.name}")
#     |> assign(:perfume, perfume)
#     |> assign(:selected_stock, stock)
#     |> assign(:stock_cart, stock_cart)
#     |> assign(:quantity, @stock_cart["quantity"] || 1)
#     |> assign(:favorite, favorite)
#     |> apply_action(socket.assigns.live_action, params)
#   end

#   defp apply_action(socket, :show, params) do
#     {:noreply, socket}
#   end

#   def handle_event("select_stock", %{"id" => id}, socket) do
#     stock = Enum.find(socket.assigns.perfume.stocks, &(&1.id == id))
#     cart_id = socket.assigns.current_cart.id

#     stock_cart =
#       Relations.get_stock_cart_by(stock_id: stock.id, cart_id: cart_id, volume: stock.volume)

#     socket =
#       socket
#       |> assign(:selected_stock, stock)
#       |> assign(:stock_cart, stock_cart)
#       |> assign(:quantity, @stock_cart["quantity"] || 1)

#     {:noreply, socket}
#   end

#   def handle_event("add_to_cart", _, socket) do
#     cart_id = socket.assigns.current_cart.id
#     # this will reise error if stock not in database
#     stock = Catalogue.get_stock!(socket.assigns.selected_stock.id)
#     locale = socket.assigns.locale

#     stock_cart_params = %{
#       cart_id: cart_id,
#       stock_id: stock.id,
#       volume: stock.volume,
#       quantity: 1
#     }

#     case 1 <= stock.quantity do
#       true ->
#         # this will reise error if stock_cart haven't been created
#         # TODO may be do second step to show what error in there maybe already in cart of message to reload the page
#         {:ok, stock_cart} = Relations.create_stock_cart(stock_cart_params)

#         message =
#           Gettext.with_locale(locale, fn ->
#             gettext("Perfume added to cart")
#           end)

#         socket =
#           socket
#           |> assign(:stock_cart, stock_cart)
#           |> put_flash(:info, message)

#         {:noreply, socket}

#       false ->
#         message =
#           Gettext.with_locale(locale, fn ->
#             gettext("There are only %{quantity} in stock", quantity: stock.quantity)
#           end)

#         socket =
#           socket
#           |> put_flash(:error, message)

#         {:noreply, socket}
#     end
#   end

#   def handle_event("add_more", _, socket) do
#     stock = Catalogue.get_stock!(socket.assigns.selected_stock.id)
#     # TODO May be not to fetcj or to update its valuse in one query
#     # this will reise error if can't fetch
#     stock_cart = Relations.get_stock_cart!(socket.assigns.stock_cart.id)
#     locale = socket.assigns.locale

#     case stock_cart.quantity < stock.quantity do
#       true ->
#         {:ok, updated_stock_cart} =
#           Relations.update_stock_cart(stock_cart, %{quantity: stock_cart.quantity + 1})

#         message =
#           Gettext.with_locale(locale, fn ->
#             gettext("Perfume added to cart")
#           end)

#         socket =
#           socket
#           |> assign(:stock_cart, updated_stock_cart)
#           |> put_flash(:info, message)

#         {:noreply, socket}

#       false ->
#         message =
#           Gettext.with_locale(locale, fn ->
#             gettext("There are only %{quantity} in stock", quantity: stock.quantity)
#           end)

#         socket =
#           socket
#           |> put_flash(:error, message)

#         {:noreply, socket}
#     end
#   end

#   def handle_event("add_to_favorite", _, socket) do
#     perfume = socket.assigns.perfume
#     cart_id = socket.assigns.current_cart.id
#     locale = socket.assigns.locale

#     case favorite_perfume?(perfume.carts_perfumes, perfume.id) do
#       false ->
#         {:ok, favorite_perfume} =
#           Relations.create_favorite_perfume(%{perfume_id: perfume.id, cart_id: cart_id})

#         Catalogue.notify_subscribers({:ok, perfume}, [:perfume, :updated])

#         message =
#           Gettext.with_locale(locale, fn ->
#             gettext("Perfume added to your favorites")
#           end)

#         socket =
#           socket
#           |> put_flash(:info, message)

#         {:noreply, socket}

#       false ->
#         message =
#           Gettext.with_locale(locale, fn ->
#             gettext("Can't add %{name} to favorites", name: perfume.name)
#           end)

#         socket =
#           socket
#           |> put_flash(:error, message)

#         {:noreply, socket}
#     end
#   end

#   def handle_event("remove_from_favorite", _, socket) do
#     perfume = socket.assigns.perfume
#     cart_id = socket.assigns.current_cart.id
#     locale = socket.assigns.locale

#     [perfume_id: perfume.id, cart_id: cart_id]
#     |> Relations.get_favorite_perfume_by!()
#     |> Relations.delete_favorite_perfume()

#     Catalogue.notify_subscribers({:ok, perfume}, [:perfume, :updated])

#     message =
#       Gettext.with_locale(locale, fn ->
#         gettext("Perfume removed from your favorites")
#       end)

#     {:noreply, put_flash(socket, :info, message)}
#   end

#   def handle_info({Catalogue, [:perfume, :updated], _}, socket) do
#     perfume = Catalogue.get_perfume!(socket.assigns.perfume.id)
#     favorite = favorite_perfume?(perfume.carts_perfumes, perfume.id)

#     socket =
#       socket
#       |> assign(:perfume, perfume)
#       |> assign(:favorite, favorite)

#     {:noreply, socket}
#   end

#   defp favorite_perfume?(carts, perfume_id) do
#     Enum.any?(carts, &(&1.perfume_id == perfume_id))
#   end
# end
