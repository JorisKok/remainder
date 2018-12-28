defmodule RemainderWeb.ErrorController do
  @moduledoc false
  use RemainderWeb, :controller

  def auth_error(conn, _messages, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401,
         Jason.encode!(
           %{
             "error" => %{
               "messages" => ["Authorization required"]
             }
           }
         )
       )

  end
end
