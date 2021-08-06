defmodule TradiexPlatformWeb.TradeLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    changeset = TradiexPlatform.Order.changeset(%TradiexPlatform.Order{})
    {:ok, assign(socket, show_price: false, changeset: changeset, valid?: false)}
  end

  @impl true
  def handle_info(:update, socket) do
    acct = TradiexPlatform.Cache.acct()
    %{"balances" => %{"total_equity" => balance}} = Tradiex.Account.get_balances(acct)
    {:noreply, socket |> assign(balance: Number.Currency.number_to_currency(balance))}
  end

  @impl true
  def handle_event("submit", %{"order" => params}, socket) do
    if Map.get(params, "order_type") == "limit" do
      %{"status" => status} =
        Tradiex.Trading.post_order(
          TradiexPlatform.Cache.acct(),
          "equity",
          Map.get(params, "symbol"),
          Map.get(params, "side"),
          Map.get(params, "quantity"),
          "limit",
          "day",
          price: Map.get(params, "price")
        )
    else
      %{"status" => status} =
        Tradiex.Trading.post_order(
          TradiexPlatform.Cache.acct(),
          "equity",
          Map.get(params, "symbol"),
          Map.get(params, "side"),
          Map.get(params, "quantity"),
          "market",
          "day"
        )
    end

    socket =
      socket
      |> put_flash(:info, "Order Submitted")
      |> push_redirect(to: Routes.orders_path(socket, :index))

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"order" => params}, socket) do
    changeset =
      TradiexPlatform.Order.changeset(%TradiexPlatform.Order{}, params)
      |> Map.put(:action, :insert)

    IO.inspect(params)
    order_type = Map.get(params, "order_type")

    {:noreply,
     assign(socket,
       show_price: order_type == "limit",
       changeset: changeset,
       valid?: changeset.valid?
     )}
  end
end
