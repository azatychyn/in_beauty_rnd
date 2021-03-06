defmodule InBeauty do
  @moduledoc """
  InBeauty keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def utc_now, do: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
end
