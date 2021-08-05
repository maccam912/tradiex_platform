defmodule TradiexPlatform.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:symbol)
    field(:side)
    field(:price)
    field(:quantity)
  end

  def changeset(order, params \\ %{}) do
    cast(order, params, [:symbol, :side, :price, :quantity])
  end
end
