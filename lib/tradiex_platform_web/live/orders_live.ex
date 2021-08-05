defmodule TradiexPlatformWeb.OrdersLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)

    {:ok, assign(socket, orders: [])}
  end

  @impl true
  def handle_info(:update, socket) do
    acct = TradiexPlatform.Cache.acct()

    orders =
      Tradiex.Account.get_orders(acct)
      |> Enum.filter(fn %{"status" => status} -> status in ["pending", "open"] end)

    {:noreply, socket |> assign(orders: orders)}
  end

  @impl true
  def handle_event("cancel", %{"id" => id}, socket) do
    acct = TradiexPlatform.Cache.acct()
    :ok = Tradiex.Trading.cancel_order(acct, id)
    Process.send_after(self(), :update, 100)
    {:noreply, socket}
  end
end
