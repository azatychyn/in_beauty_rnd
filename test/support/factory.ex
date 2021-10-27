defmodule InBeautyWeb.Factory do
  @moduledoc """
  This module defines the factory for models
  """

  use ExMachina.Ecto, repo: InBeauty.Repo

  alias InBeauty.Accounts.User
  alias InBeauty.Catalogue.Perfume
  alias InBeauty.Stocks.Stock

  def user_factory do
    %User{
      email: sequence(:email, &"email_#{&1}@example.com"),
      confirmed_at: &InBeauty.utc_now/0
      # name: sequence(:name, &"name_#{&1}"),
    }
  end

  def perfume_factory do
    %Perfume{
      description: sequence(:description, &"some_#{&1}description"),
      gender: Enum.random(Ecto.Enum.values(Perfume, :gender)),
      manufacturer: sequence(:manufacturer, &"some_#{&1}manufacturer"),
      name: sequence(:name, &"some_#{&1}name"),
      stocks: build_pair(:stock)
    }
  end

  def stock_factory do
    %Stock{
      image_path: sequence(:image_path, &"some_#{&1}image_path"),
      price: sequence(:price, &(&1 + 1)),
      quantity: sequence(:quantity, &(&1 + 1)),
      volume: sequence(:volume, &(&1 + 1)),
      weight: sequence(:weight, &(&1 + 1))
    }
  end
end
