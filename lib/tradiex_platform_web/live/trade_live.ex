defmodule TradiexPlatformWeb.TradeLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    changeset = TradiexPlatform.Order.changeset(%TradiexPlatform.Order{})
    {:ok, assign(socket, changeset: changeset, valid?: false)}
  end

  @impl true
  def handle_info(:update, socket) do
    acct = TradiexPlatform.Cache.acct()
    %{"balances" => %{"total_equity" => balance}} = Tradiex.Account.get_balances(acct)
    {:noreply, socket |> assign(balance: Number.Currency.number_to_currency(balance))}
  end

  @impl true
  def handle_event("submit", %{"order" => params}, socket) do
    status =
      Tradiex.Trading.equity_market_order(
        TradiexPlatform.Cache.acct(),
        Map.get(params, "symbol"),
        Map.get(params, "quantity")
      )

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

    {:noreply, assign(socket, changeset: changeset, valid?: changeset.valid?)}
  end
end
