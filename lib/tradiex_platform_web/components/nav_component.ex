defmodule TradiexPlatformWeb.NavComponent do
  use Surface.Component
  alias Surface.Components.LiveRedirect

  def render(assigns) do
    ~F"""
    <nav class="tabs tabs-boxed">
    <LiveRedirect to="/">Account</LiveRedirect>
    <LiveRedirect to="/portfolio">Portfolio</LiveRedirect>
    <LiveRedirect to="/orders">Orders</LiveRedirect>
    <LiveRedirect to="/trade">Trade</LiveRedirect>
    <LiveRedirect to="/optionschain">Options Chain</LiveRedirect>
    </nav>
    """
  end
end
