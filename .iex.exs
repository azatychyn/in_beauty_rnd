import Ecto.Query
# import InBeauty.Factories

alias InBeauty.Repo

alias InBeauty.Accounts
alias InBeauty.Accounts.{User, UserToken}
alias InBeauty.Catalogue
alias InBeauty.Catalogue.{Perfume, Review}
alias InBeauty.Stocks.{Stock, ReservedStock}
alias InBeauty.Deliveries
alias InBeauty.Deliveries.{Delivery, DeliveryPoint}
alias InBeauty.Payments
alias InBeauty.Payments.Order
alias InBeauty.Carts.Cart
alias InBeauty.Carts
alias InBeauty.Relations.{StockCart, StockOrder, FavoriteProduct}
