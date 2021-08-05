defmodule TradiexPlatform.OptionsChain do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:symbol)
    field(:expiration)
    field(:strike)
    field(:side)
  end

  def changeset(order, params \\ %{}) do
    IO.inspect(
      order
      |> cast(params, [:symbol, :expiration, :strike, :side])
      |> validate_required([:symbol, :expiration, :strike, :side])
      |> validate_symbol()
    )
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
