defmodule RemainderWeb.EmployeeControllerListTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, EmployeeFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "GET /v1/employees", %{conn: conn, user: user, token: token} do
    EmployeeFactory.create(%{user_id: user.id})
    EmployeeFactory.create(%{user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/employees")
                 |> json_count == 2
  end

  test "GET /v1/employees only returns logged in user's employees", %{conn: conn, user: user, token: token} do
    {:ok, %{user: other_user}} = UserFactory.create
    EmployeeFactory.create(%{user_id: user.id})
    EmployeeFactory.create(%{user_id: other_user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/employees")
                 |> json_count == 1
  end
end
