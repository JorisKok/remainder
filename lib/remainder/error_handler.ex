defmodule Remainder.ErrorHandler do
  @moduledoc false
  use RemainderWeb, :controller
  plug :put_view, RemainderWeb.ErrorView

  def auth_error(conn, messages, opts) do
    IO.inspect(messages) # TODO remove
    IO.inspect(opts) # TODO remove
    send_resp(conn, 401, ["authentication"])
  end
end
