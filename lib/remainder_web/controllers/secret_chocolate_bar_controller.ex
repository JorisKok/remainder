defmodule RemainderWeb.SecretChocolateBarController do
  use RemainderWeb, :controller
  @moduledoc false

  def index(conn, _params) do
    render(conn, "index.json")
  end
end
