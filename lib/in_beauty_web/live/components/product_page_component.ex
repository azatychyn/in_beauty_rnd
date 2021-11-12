defmodule InBeautyWeb.ProductPageComponent do
  use Phoenix.Component

  @doc """
  Renders a product page.

  ## Examples
  	<InBeautyWeb.ProductPageComponent.render_page 				
  		page={page}, 
  		product={product},
  		page_size={page_size}
  	/>	
  """
  def render_page(assigns) do
    ~H"""
    <div           
      class="
        grid
        grid-cols-2
        lg:grid-cols-3
        xl:grid-cols-4
        2xl:grid-cols-5
        place-items-center
        gap-4
        sm:gap-8
        xl:gap-12
        mt-8
        xl:mt-16
      "
      >           
        <%= if @page != [] do %>
          <%= for product <- @page do %>          
            <InBeautyWeb.ProductCardComponent.loaded_product product={product} />
          <% end %>
        <% else %>            
          <%= for _i <- 1..@page_size do %>        
            <InBeautyWeb.ProductCardComponent.unloaded_product />
          <% end %>
        <% end %>                
    </div>
    """
  end
end
