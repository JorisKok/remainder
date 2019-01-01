defmodule RemainderWeb.EmployeeControllerUpdateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, EmployeeFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "PATCH /v1/employees/:id", %{conn: conn, user: user, token: token} do
    {:ok, %{employee: employee}} = EmployeeFactory.create(%{user_id: user.id})

    params = %{
      "email" => "bobby-rossy@example.com",
      "first_name" => "Bobby",
      "last_name" => "Rossy",
    }
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/employees/#{employee.id}", params)
                 |> json_data == %{
                   "email" => "bobby-rossy@example.com",
                   "first_name" => "Bobby",
                   "last_name" => "Rossy"
                 }
  end

  test "PATCH /v1/employees/:id gets 404 when the employee does not belong to the user", %{conn: conn, token: token} do
    {:ok, %{user: other_user}} = UserFactory.create
    {:ok, %{employee: employee}} = EmployeeFactory.create(%{user_id: other_user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/employees/#{employee.id}", %{})
                 |> json_not_found == ["Not found"]
  end

end
