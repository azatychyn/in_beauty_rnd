defmodule InBeautyWeb.Forms.ProductFilterFormComponent do
  use InBeautyWeb, :live_component
  alias InBeauty.Catalogue
  @impl Phoenix.LiveComponent
  def mount(socket) do    
    {:ok, assign(socket, :all_selected_filteres, [])}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
      <form phx-change="filter" phx-target={@myself} class="bg-gray-100 bg-opacity-40 rounded-2xl p-10 p-8">
        <input type="hidden" name="page_size" value={ @filter_options.page_size }>
        <input type="hidden" name="page" value={ @filter_options.page }>
        
        <section class="grid grid-cols-1 rounded-2xl mt-4 text-midnight-500 dark:text-rose-100">
          <%= if @device == "mobile" do %>
            <InBeautyWeb.MultiSelectComponent.mobile     
              variants={@volumes_variants}, #TODO do list with enums for ecto
              selected_variants={@filter_options.volumes}
              field={"volumes"}
              placeholder={gettext("Volume")}
              device={@device} 
            />                  
          <% else %>
              <InBeautyWeb.MultiSelectComponent.desktop                   
              variants={@volumes_variants}, #TODO do list with enums for ecto
              selected_variants={@filter_options.volumes}
              field={"volumes"}
              placeholder={gettext("Volume")}
              device={@device} 
            />
          <% end %>

          <%= if @device == "mobile" do %>
            <InBeautyWeb.MultiSelectComponent.mobile     
              variants={@genders_variants} #TODO do list with enums for ecto
              selected_variants={@filter_options.genders}
              field={"genders"}
              placeholder={gettext("Gender")}
              device={@device} 
            />                  
          <% else %>
              <InBeautyWeb.MultiSelectComponent.desktop                   
              variants={@genders_variants}, #TODO do list with enums for ecto
              selected_variants={@filter_options.genders}
              field={"genders"}
              placeholder={gettext("Gender")}
              device={@device} 
            />
          <% end %>   
          <%= if @device == "mobile" do %>
            <InBeautyWeb.MultiSelectComponent.mobile     
              variants={@manufacturers_variants} #TODO do list with enums for ecto
              selected_variants={@filter_options.manufacturers}
              field={"manufacturers"}
              placeholder={gettext("Manufacturer")}
              device={@device} 
            />                  
          <% else %>
              <InBeautyWeb.MultiSelectComponent.desktop                   
              variants={@manufacturers_variants} #TODO do list with enums for ecto
              selected_variants={@filter_options.manufacturers}
              field={"manufacturers"}
              placeholder={gettext("Manufacturer")}
              device={@device} 
            />
          <% end %>                        
        </section>

        <ul class="mt-6">
          <%= for {filter_group, selected_filter} <- all_selected_filters(@filter_options) do %>			
            <li class="inline-flex items-center justify-center p-6 bg-gradient-to-r from-rose-100 to-rose-200 dark:border-rose-300 rounded-2xl text-xl text-center whitespace-nowrap cursor-pointer">
              <p class="">
                <%= selected_filter %>
              </p>
              <a
                class="ml-1"
                phx-click="remove_filter"
                phx-target={@myself}
                phx-value-filter_group={filter_group}
                phx-value-filter={selected_filter}
              >					
                <%= icon_tag("x", class: "w-7 h-7") %> 
              </a>
            </li>
          <% end %>
        </ul>	        
        <div class="grid grid-cols-2 mt-12">
          <p class="flex items-center text-xl xs:text-2xl sm:text-3xl md:text-5xl text-midnight-500 dark:text-rose-100">
            <%= gettext("Find items:") %>
            <strong class="flex items-center justify-center text-midnight-400 dark:text-rose-200 p-2 mx-2 sm:mx-4 text-4xl"> <%= "#{@perfumes_count}" %></strong>
          </p>
          <%= reset(gettext("Reset All Filters"),
                "phx-click": "reset_filters",
                "phx-throttle": "1000",
                "phx-target":  @myself,
                class: "place-self-end max-w-xs underline text-base xs:text-xl sm:text-2xl text-gray-100 hover:text-gray-500 dark:text-rose-100 font-medium py-2 px-0 sm:px-2 md:px-4 ml-auto bg-transparent rounded-2xl cursor-pointer text-center"
              )
          %>
        </div>        
          <%= live_redirect("Show #{@perfumes_count}",
                to: Routes.perfume_index_path(@socket, :index, @filter_options),
                class: "block sm:w-auto uppercase p-4 xs:px-12 sm:px-6 md:px-8 xs:py-6 md:py-8 text-3xl dark:text-rose-100 font-bold bg-rose-100 hover:bg-rose-200 dark:bg-denim-500 dark:hover:bg-denim-400 rounded-2xl cursor-pointer text-center mt-16"
              ) %>        
      </form>
    """
  end

  @impl Phoenix.LiveComponent
  def handle_event("filter", params, socket) do
    filter_options = %{
      page: params["page"],
      page_size: params["page_size"] || "1",
      genders: Enum.uniq(params["genders"]) || [],
      volumes: Enum.uniq(params["volumes"]) || [],
      manufacturers: Enum.uniq(params["manufacturers"]) || [],
      price: params["price"] || ["0", "10000"]
    }

    {
      :noreply,      
      push_patch(socket,
        to: Routes.perfume_index_path(socket, :filters, filter_options),
        replace: true
      )
    }
  end

  def handle_event("reset_filters", _, socket) do
    filter_options = %{
      genders: [],
      volumes: [],
      manufacturers: [],
      price: ["0", "10000"]
    }

    {:noreply,
     push_patch(socket,
       to: Routes.perfume_index_path(socket, :filters, filter_options),
       replace: true
     )}
  end

  def handle_event("remove_filter", %{"filter_group" => filter_group, "filter" => filter}, socket) do
    filter_group = String.to_existing_atom(filter_group)

    filter_options =
      socket.assigns.filter_options
      |> update_in([filter_group], &List.delete(&1, filter))

    {:noreply,
     push_patch(socket,
       to: Routes.perfume_index_path(socket, :filters, filter_options),
       replace: true
     )}
  end

  def handle_event("price_change", [price_min, price_max], socket) do
    filter_options = Map.put(socket.assigns.filter_options, :price, [price_min, price_max])

    {:noreply,
     push_patch(socket,
       to: Routes.perfume_index_path(socket, :filters, filter_options),
       replace: true
     )}
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
end
