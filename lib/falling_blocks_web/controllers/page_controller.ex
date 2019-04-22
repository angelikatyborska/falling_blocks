defmodule FallingBlocksWeb.PageController do
  use FallingBlocksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
