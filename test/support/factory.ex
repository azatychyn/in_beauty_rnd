defmodule InBeautyWeb.Factory do
  @moduledoc """
  This module defines the factory for models
  """

  use ExMachina.Ecto, repo: InBeauty.Repo

  alias InBeauty.Accounts.User
  alias InBeauty.Catalogue.Perfume
  alias InBeauty.Stocks.{ReservedStock, Stock}
  alias InBeauty.Carts.Cart
  alias InBeauty.Relations.{StockCart, StockOrder}
  alias InBeauty.Payments.Order
  alias InBeauty.Deliveries.{Delivery, DeliveryPoint}

  def user_factory do
    %User{
      email: sequence(:email, &"email_#{&1}@example.com"),
      hashed_password: Bcrypt.hash_pwd_salt(sequence(:poassword, &"password_#{&1}")),
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
      price: 50,
      quantity: sequence(:quantity, &(&1 + 1)),
      volume: 30,
      weight: sequence(:weight, &(&1 + 1)),
      perfume: nil
    }
  end

  def stock_order_factory do
    %StockOrder{
      quantity: sequence(:quantity, &(&1 + 1)),
      volume: 30,
      stock: build(:stock)
    }
  end

  def reserved_stock_factory do
    %ReservedStock{
      quantity: sequence(:quantity, &(&1 + 1)),
      volume: sequence(:volume, &(&1 + 1)),
      stock: nil,
      order: nil
    }
  end

  def stock_cart_factory do
    %StockCart{
      quantity: sequence(:quantity, &(&1 + 1)),
      volume: 30
    }
  end

  def cart_factory do
    %Cart{
      anon: false,
      product_count: 0,
      total_price: 0,
      session_id: &Ecto.UUID.generate/0
    }
  end

  def order_factory do
    %Order{
      comment: sequence(:comment, &"comment_#{&1}"),
      email: sequence(:email, &"email_#{&1}@gmail.com"),
      first_name: sequence(:first_name, &"first_name_#{&1}"),
      last_name: sequence(:last_name, &"last_name_#{&1}"),
      patronymic: sequence(:patronymic, &"patronymic_#{&1}"),
      phone_number: "79996990099",
      status: "some status",
      user: build(:user),
      delivery: build(:delivery),
      reserved_stocks: build_pair(:reserved_stock)
    }
  end

  def delivery_factory do
    %Delivery{
      private_house: false,
      house_type_full: nil,
      region_type: "обл",
      delivery_type: :sdek_pickup,
      delivery_point: build(:delivery_point),
      date: nil,
      region_type_full: "область",
      city_fias_id: "c1cfe4b9-f7c2-423c-abfa-6ed1c05a15c5",
      settlement: nil,
      area_type_full: nil,
      house: nil,
      region_kladr_id: "6100000000000",
      settlement_type: nil,
      house_kladr_id: nil,
      area_type: nil,
      updated_at: nil,
      longitude: 39.718705,
      street_type: nil,
      street_fias_id: nil,
      settlement_type_full: nil,
      area: nil,
      area_kladr_id: nil,
      house_fias_id: nil,
      status: nil,
      street: nil,
      city_kladr_id: "6100000100000",
      street_type_full: nil,
      flat_type_full: nil,
      region: "Ростовская",
      sdek_city_code: 438,
      city_type_full: "город",
      flat_fias_id: nil,
      city_type: "г",
      house_type: nil,
      latitude: 47.222531,
      city: "Ростов-на-Дону",
      city_district_kladr_id: nil,
      settlement_fias_id: nil,
      inserted_at: nil,
      flat: nil,
      flat_type: nil,
      area_fias_id: nil,
      region_fias_id: "f10763dc-63e3-48db-83e1-9c566fe3092b",
      settlement_kladr_id: nil
    }
  end

  def delivery_point_factory do
    %DeliveryPoint{
      address: "пл. Карла Маркса, 9а",
      address_full: "Россия, Ростовская обл., Ростов-на-Дону, пл. Карла Маркса, 9а",
      allowed_cod: nil,
      city: "Ростов-на-Дону",
      city_code: nil,
      code: nil,
      have_cash: nil,
      have_cashless: nil,
      id: nil,
      is_handout: nil,
      latitude: nil,
      longitude: nil,
      name: nil,
      owner_code: nil,
      type: nil,
      work_time: nil
    }
  end
end
