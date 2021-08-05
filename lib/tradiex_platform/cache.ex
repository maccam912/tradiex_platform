defmodule TradiexPlatform.Cache do
  use GenServer

  def start_link(_opt) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opt) do
    {:ok, %{}}
  end

  def handle_call(:etb, _from, state) do
    etb = Map.get(state, :etb)

    etb =
      if is_nil(etb) do
        Tradiex.MarketData.get_etb_securities()
      else
        etb
      end

    {:reply, etb, Map.put(state, :etb, etb)}
  end

  def handle_call(:acct, _from, state) do
    acct = Map.get(state, :acct)

    acct =
      if is_nil(acct) do
        %{"account_number" => acct} = Tradiex.Account.get_user_profile()
        acct
      else
        acct
      end

    {:reply, acct, Map.put(state, :acct, acct)}
  end

  def etb() do
    GenServer.call(__MODULE__, :etb)
  end

  def acct() do
    GenServer.call(__MODULE__, :acct)
  end
end
