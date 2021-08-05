defmodule TradiexPlatformWeb.OptionsChainLive do
  use TradiexPlatformWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)
    changeset = TradiexPlatform.OptionsChain.changeset(%TradiexPlatform.OptionsChain{})

    {:ok,
     assign(socket, expirations: [], strikes: [], chain: [], changeset: changeset, valid?: false)}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"options_chain" => params}, socket) do
    changeset =
      TradiexPlatform.OptionsChain.changeset(%TradiexPlatform.OptionsChain{}, params)
      |> Map.put(:action, :insert)

    expirations =
      if is_nil(Keyword.get(changeset.errors, :symbol)) do
        Tradiex.MarketData.get_option_expirations(Map.get(params, "symbol"))
      else
        []
      end

    chain =
      if !is_nil(Map.get(params, "symbol")) and !is_nil(Map.get(params, "expiration")) do
        # Got symbol and expiration, lets get chain
        Tradiex.MarketData.get_option_chains(
          Map.get(params, "symbol"),
          Map.get(params, "expiration")
        )
      else
        []
      end

    {:noreply,
     assign(socket,
       changeset: changeset,
       expirations: expirations,
       chain: format_options(chain),
       valid?: changeset.valid?
     )}
  end

  defp format_options(chain) do
    chainmap =
      chain
      |> Enum.map(fn %{"option_type" => type, "strike" => strike} = opt ->
        {strike, type, opt}
      end)
      |> Enum.reduce(%{}, fn {strike, option_type, opt}, acc ->
        curr = Map.get(acc, strike, %{})
        curr = Map.put(curr, option_type, opt)
        Map.put(acc, strike, curr)
      end)
      |> Enum.map(fn {k, v} -> {k, v} end)
      |> Enum.sort_by(fn {a, _} -> a end)

    chainmap
  end
end
