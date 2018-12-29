defmodule RemainderWeb.ErrorController do
  @moduledoc false
  use RemainderWeb, :controller

  def auth_error(conn, _messages, _opts) do
    conn
    |> put_status(401)
    |> put_view(RemainderWeb.ErrorView)
    |> render("auth_error.json")
  end
end
