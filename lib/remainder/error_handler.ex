defmodule Remainder.ErrorHandler do
  @moduledoc false
  use RemainderWeb, :controller
  plug :put_view, RemainderWeb.ErrorView

  def auth_error(conn, _messages,_opts) do
    send_resp(conn, 422, ["authentication"])
  end
end
