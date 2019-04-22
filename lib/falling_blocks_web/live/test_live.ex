defmodule FallingBlocksWeb.TestLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    Counter: <%= @counter %>
    <a phx-click="inc">more</a>
    <a phx-click="dec">less</a>
    """
  end

  def mount(_assigns, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), "tick")
    end

    {:ok, assign(socket, :counter, 1)}
  end

  def handle_event("inc", _, socket) do
    {:noreply, assign(socket, :counter, socket.assigns.counter + 1)}
  end

  def handle_event("dec", _, socket) do
    {:noreply, assign(socket, :counter, socket.assigns.counter - 1)}
  end

  def handle_info("tick", socket) do
    {:noreply, assign(socket, :counter, socket.assigns.counter + 1)}
  end
end
