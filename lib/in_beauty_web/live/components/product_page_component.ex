defmodule InBeautyWeb.ProductPageComponent do
  use Phoenix.Component
  alias InBeautyWeb.Router.Helpers, as: Routes

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
      id={@page}      
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
      <%= if @product do %>				        
        <%= if !@product[:loading?] do %>
          <%= for perfume <- @product.perfumes do %>
            <InBeautyWeb.ProductCardComponent.loaded_product product={perfume} />                       
          <% end %>
        <% else %>            
          <%= for i <- 1..@page_size do %>        
            <InBeautyWeb.ProductCardComponent.unloaded_product />          
          <% end %>
        <% end %>                
      <% end %>
    </div>
    """
  end
end
