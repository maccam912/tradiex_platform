defmodule TradiexPlatformWeb.PortfolioLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)

    {:ok, assign(socket, positions: [])}
  end

  @impl true
  def handle_info(:update, socket) do
    acct = TradiexPlatform.Cache.acct()
    positions = Tradiex.Account.get_positions(acct)
    {:noreply, socket |> assign(positions: positions, acct: acct)}
  end

  @impl true
  def handle_event("close", %{"symbol" => symbol}, socket) do
    Tradiex.Trading.equity_position_close(socket.assigns.acct, symbol)
    Process.send_after(self(), :update, 1000)
    {:noreply, socket}
  end
end
