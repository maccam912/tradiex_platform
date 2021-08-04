defmodule TradiexPlatformWeb.AccountLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)

    {:ok, assign(socket, balance: Number.Currency.number_to_currency(0))}
  end

  @impl true
  def handle_info(:update, socket) do
    %{"account_number" => acct} = Tradiex.Account.get_user_profile()
    %{"balances" => %{"total_equity" => balance}} = Tradiex.Account.get_balances(acct)
    {:noreply, socket |> assign(balance: Number.Currency.number_to_currency(balance))}
  end

  # @impl true
  # def handle_event("search", %{"q" => query}, socket) do
  #   case search(query) do
  #     %{^query => vsn} ->
  #       {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

  #     _ ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:error, "No dependencies found matching \"#{query}\"")
  #        |> assign(results: %{}, query: query)}
  #   end
  # end
end
