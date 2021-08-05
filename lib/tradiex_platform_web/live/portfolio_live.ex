defmodule TradiexPlatformWeb.PortfolioLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)

    {:ok, assign(socket, positions: [])}
  end

  @impl true
  def handle_info(:update, socket) do
    %{"account_number" => acct} = Tradiex.Account.get_user_profile()
    positions = IO.inspect Tradiex.Account.get_positions(acct)
    {:noreply, socket |> assign(positions: positions, acct: acct)}
  end

  @impl true
  def handle_event("close", %{"symbol" => symbol}, socket) do
    IO.inspect symbol
    Tradiex.Trading.equity_position_close(socket.assigns.acct, symbol)
    Process.send_after(self(), :update, 1000)
    {:noreply, socket}
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
