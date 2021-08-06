defmodule TradiexPlatformWeb.NavComponent do
  use TradiexPlatformWeb, :live_component

  def classes(assigns, name) do
    if String.contains?(to_string(assigns.view), name) do
      "btn btn-primary btn-sm rounded-btn navbar-center"
    else
      "btn btn-ghost btn-sm rounded-btn"
    end
  end

  def render(assigns) do
    ~L"""
    <div class="divider"></div>
    <nav class="navbar">
    <div class="navbar-start"></div>
    <%= live_redirect("Account", to: Routes.account_path(@socket, :index), class: classes(@socket, "Account")) %>
    <%= live_redirect("Portfolio", to: Routes.portfolio_path(@socket, :index), class: classes(@socket, "Portfolio")) %>
    <%= live_redirect("Orders", to: Routes.orders_path(@socket, :index), class: classes(@socket, "Orders")) %>
    <%= live_redirect("Trade", to: Routes.trade_path(@socket, :index), class: classes(@socket, "Trade")) %>
    <%= live_redirect("Options Chain", to: Routes.options_chain_path(@socket, :index), class: classes(@socket, "OptionsChain")) %>
    <div class="navbar-end"></div>
    </nav>
    <div class="divider"></div>
    """
  end
end
