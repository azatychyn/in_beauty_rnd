defmodule InBeautyWeb.ProductCardComponent do
  use Phoenix.Component

  import InBeautyWeb.LiveHelpers, only: [icon_tag: 1, icon_tag: 2]

  alias InBeautyWeb.Router.Helpers, as: Routes

  @doc """
  Renders an unloaded product card.

  ## Examples
    <InBeautyWeb.ProductCardComponent.unloaded_product />  
  """
  def unloaded_product(assigns) do
    ~H"""
    <li class="flex flex-col justify-center items-center w-full sm:w-max max-w-sm rounded-2xl p-1">
      <div class="relative w-full h-7/12 sm:h-32 text-gray-100 dark:text-denim-300">
        <div class="absolute bg-rose-100 dark:bg-opacity-90 rounded-t-2xl h-1/2 w-full -z-10 bottom-0">
        </div>
        <a class="block transform hover:scale-110 h-full w-7/12 sm:w-32 object-cover rounded-2xl mx-auto animate-pulse">                      
          <%= icon_tag("photograph", class: "w-full h-full") %>    
        </a>
      </div>
      <div class="flex flex-col items-center w-full sm:w-64 h-auto bg-rose-100 dark:bg-opacity-90 py-1 xs:py-4">
        <p class="text-denim-400 h-6 xs:h-7 w-10/12 bg-gray-50 dark:bg-denim-500 rounded-2xl animate-pulse sm:mb-2"></p>
        <p class="text-denim-300 animate-pulse bg-gray-50 dark:bg-denim-400 rounded-2xl h-6 w-24"></p>
      </div>
      <div class="w-full relative">
        <p class="absolute bg-rose-100 dark:bg-opacity-90 rounded-b-2xl h-1/2 w-full -z-10 top-0"></p>
        <p class="flex mx-auto text-xs bg-denim-500 dark:bg-denim-400 text-white hover:text-rose-100 transform hover:scale-110 rounded-2xl max-h-16 w-4/12 sm:w-16 shadow-lg text-thin p-3 animate-pulse">                    
          <%= icon_tag("cart") %>       
        </p>
      </div>
    </li>
    """
  end

  ## TODO maybe chek if with socket redirects are faster than with endpoint

  @doc """
  Renders an loaded product card.

  ## Examples
    <InBeautyWeb.ProductCardComponent.loaded_product product={perfume} />  
  """
  def loaded_product(assigns) do
    ~H"""
    <li class="flex flex-col justify-center items-center w-full sm:w-max max-w-sm rounded-2xl p-1">
      <%=  Phoenix.HTML.Link.link to: Routes.perfume_show_url(InBeautyWeb.Endpoint, :show, @product.id), class: "relative w-full h-7/12 sm:h-32", target: "_blank", rel: "noopener noreferrer" do %>
      <div class="absolute bg-rose-100 dark:bg-opacity-90 rounded-t-2xl h-1/2 w-full -z-10 bottom-0">
      </div>
        <!-- TODO to do images samll for different sizes -->
        <%= if @product.stocks not in [nil, []] do %>
          <img class="block transform hover:scale-110 h-7/12 sm:h-32 w-7/12 sm:w-32 object-cover rounded-2xl mx-auto" src={extract_image(@product.stocks)} alt="product-image">
        <% end %>
      <% end %>
      <div class="flex flex-col items-center w-full sm:w-64 h-auto bg-rose-100 dark:bg-opacity-90 py-1 xs:py-4">
        <%= Phoenix.HTML.Link.link @product.name, to: Routes.perfume_show_path(InBeautyWeb.Endpoint, :show, @product.id), class: "w-10/12 text-center tracking-widest font-bold text-denim-500 overflow-y-scroll text-base xs:text-lg sm:mb-2 ", target: "_blank", rel: "noopener noreferrer"  %>          
        <p class="w-max text-denim-500 text-base">$129</p>
      </div>
      <div class="flex w-full relative">
        <div class="absolute bg-rose-100 dark:bg-opacity-90 rounded-b-2xl h-1/2 w-full -z-10 top-0">
        </div>
        <a class="flex mx-auto text-xs bg-denim-500 dark:bg-denim-400 text-white hover:text-rose-100 transform hover:scale-110 rounded-2xl max-h-16 w-4/12 sm:w-16 shadow-lg  p-3 cursor-pointer">
        <%= icon_tag("cart") %>
        
        </a>
      </div>
    </li>
    """
  end

  defp extract_image([stock | stocks]) do
    stock.image_path
  end
end
