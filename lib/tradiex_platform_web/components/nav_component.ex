defmodule TradiexPlatformWeb.NavComponent do
  use TradiexPlatformWeb, :live_component

  def classes(assigns, name) do
    if String.contains?(to_string(assigns.view), name) do
      "tab tab-active"
    else
      "tab"
    end
  end

  def render(assigns) do
    ~L"""
    <nav class="tabs tabs-boxed">
    <%= live_redirect("Account", to: Routes.account_path(@socket, :index), class: classes(@socket, "Account")) %>
    <%= live_redirect("Portfolio", to: Routes.account_path(@socket, :index), class: classes(@socket, "Portfolio")) %>
    </nav>
    """
  end
end