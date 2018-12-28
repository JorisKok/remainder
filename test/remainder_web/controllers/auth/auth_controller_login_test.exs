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

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/secret-chocolate-bar")
                 |> json_data == %{"message" => "You found it!"}
  end

  # TODO if email is wrong
end
