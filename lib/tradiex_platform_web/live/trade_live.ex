defmodule TradiexPlatformWeb.TradeLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: %{})}
  end

  @impl true
  def handle_info(:update, socket) do
    %{"account_number" => acct} = Tradiex.Account.get_user_profile()
    %{"balances" => %{"total_equity" => balance}} = Tradiex.Account.get_balances(acct)
    {:noreply, socket |> assign(balance: Number.Currency.number_to_currency(balance))}
  end
end
