defmodule RemainderWeb.EmployeeControllerDeleteTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, EmployeeFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "DELETE /v1/employee", %{conn: conn, user: user, token: token} do
    {:ok, %{employee: employee}} = EmployeeFactory.create(%{user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/employees/#{employee.id}")
                 |> json_no_response == true
  end

  test "DELETE /v1/employee cannot delete an employee of a different user", %{conn: conn, token: token} do
    {:ok, %{employee: employee}} = EmployeeFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/employees/#{employee.id}")
                 |> json_auth_error == ["Authorization required"]
  end

end
