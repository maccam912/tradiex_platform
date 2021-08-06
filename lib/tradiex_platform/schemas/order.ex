defmodule TradiexPlatform.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:symbol)
    field(:side)
    field(:order_type)
    field(:price, :float)
    field(:quantity, :integer)
  end

  def changeset(order, params \\ %{}) do
    order
    |> cast(params, [:symbol, :side, :order_type, :price, :quantity])
    |> validate_required([:symbol, :side, :order_type, :quantity])
    |> validate_symbol()
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:quantity, greater_than: 0)
  end

  def validate_symbol(changeset) do
    symbol = get_field(changeset, :symbol)

    symbols =
      TradiexPlatform.Cache.etb()
      |> Enum.map(fn %{"symbol" => symbol} -> symbol end)

    if symbol in symbols do
      changeset
    else
      add_error(changeset, :symbol, "is not on the etb list")
    end
  end
end
