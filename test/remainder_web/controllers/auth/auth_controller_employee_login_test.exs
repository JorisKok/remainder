defmodule RemainderWeb.AuthControllerEmployeeLoginTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.EmployeeFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    EmployeeFactory.create
  end

  test "POST /v1/auth/login returns a token that we can use for authentication", %{conn: conn} do
    params = %{
      email: "employee@example.com",
      password: "secret",
    }

    %{"token" => token} = conn |> post("/v1/auth/login", params) |> json_data

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/secret-chocolate-bar")
                 |> json_data == %{"message" => "You found it!"}
  end

  test "POST /v1/secret-chocolate-bar get an error message when token is wrong", %{conn: conn} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: WrongToken")
                 |> get("/v1/secret-chocolate-bar")
                 |> json_auth_error == ["Authorization required"]
  end
end
