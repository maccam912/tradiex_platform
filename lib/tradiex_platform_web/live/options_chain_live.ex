defmodule TradiexPlatformWeb.OptionsChainLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)
    changeset = TradiexPlatform.OptionsChain.changeset(%TradiexPlatform.OptionsChain{})

    {:ok, assign(socket, orders: [], expirations: [], changeset: changeset, valid?: false)}
  end

  @impl true
  def handle_info(:update, socket) do
    acct = TradiexPlatform.Cache.acct()

    {:noreply, assign(socket, acct: acct, options_chain: %{})}
  end

  @impl true
  def handle_event("validate", %{"options_chain" => params}, socket) do
    changeset =
      TradiexPlatform.Order.changeset(%TradiexPlatform.Order{}, params)
      |> Map.put(:action, :insert)

    expirations =
      if is_nil(Keyword.get(changeset.errors, :symbol)) do
        Tradiex.MarketData.get_option_expirations(Map.get(params, "symbol"))
      else
        []
      end

    {:noreply,
     assign(socket, changeset: changeset, expirations: expirations, valid?: changeset.valid?)}
  end
end
