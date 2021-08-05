defmodule TradiexPlatformWeb.AccountLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)

    {:ok, assign(socket, balance: Number.Currency.number_to_currency(0))}
  end

  @impl true
  def handle_info(:update, socket) do
    acct = TradiexPlatform.Cache.acct()
    %{"balances" => %{"total_equity" => balance}} = Tradiex.Account.get_balances(acct)
    {:noreply, socket |> assign(balance: Number.Currency.number_to_currency(balance))}
  end
end
