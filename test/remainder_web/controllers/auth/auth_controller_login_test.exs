defmodule RemainderWeb.AuthControllerLoginTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.UserFactory
  import AssertValue
  import RemainderWeb.TestHelper


  test "POST /v1/auth/login can get a token and use it to login", %{conn: conn} do
    UserFactory.create_user()

    params = %{
      email: "admin@example.com",
      password: "secret",
    }

    %{"token" => token} = post(conn, "/v1/auth/login", params) |> json_data

    # TODO finish this
    assert_value get(conn, "/v1/secret-chocolate-bar") |> json_data
  end

  # TODO if email is wrong
end
