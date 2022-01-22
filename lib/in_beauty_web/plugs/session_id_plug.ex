defmodule InBeautyWeb.Plugs.SessionPlug do
  import Plug.Conn

  alias InBeauty.Payments
  alias InBeauty.Repo

  def init(_opts), do: nil

  def call(%{private: %{:plug_session => %{"session_id" => session_id}}} = conn, _opts)
      when not is_nil(session_id),
      do: conn

  def call(conn, _opts),
    do: put_session(conn, "session_id", Ecto.UUID.generate())
end
