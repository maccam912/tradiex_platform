defmodule TradiexPlatform.Cache do
  use GenServer

  def start_link(_opt) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opt) do
    {:ok, %{}}
  end

  def handle_info(:clear_balance, state) do
    {:noreply, Map.delete(state, :balance)}
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

  def handle_call(:balance, _from, state) do
    acct = Map.get(state, :acct)
    balance = Map.get(state, :balance)

    balance =
      if is_nil(balance) do
        %{"balances" => %{"total_equity" => balance}} = Tradiex.Account.get_balances(acct)
        balance
      else
        balance
      end

    {:reply, balance, Map.put(state, :balance, balance)}
  end

  def etb() do
    GenServer.call(__MODULE__, :etb)
  end

  def acct() do
    GenServer.call(__MODULE__, :acct)
  end

  def balance() do
    GenServer.call(__MODULE__, :acct)
    GenServer.call(__MODULE__, :balance)
  end

  defp clear_balance() do
    Process.send_after(self(), :clear, 30000)
    GenServer.cast(__MODULE__, :clear_balance)
  end
end
