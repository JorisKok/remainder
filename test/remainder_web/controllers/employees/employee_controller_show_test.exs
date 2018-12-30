defmodule RemainderWeb.EmployeeControllerShowTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, EmployeeFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "GET /v1/employees/:id", %{conn: conn, user: user, token: token} do
    {:ok, %{employee: employee}} = EmployeeFactory.create(
      %{
        email: "show-employee@example.com",
        first_name: "Bob",
        last_name: "Ross",
        user_id: user.id
      }
    )

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/employees/#{employee.id}")
                 |> json_data == %{
                   "email" => "show-employee@example.com",
                   "first_name" => "Bob",
                   "last_name" => "Ross"
                 }
  end

  test "GET /v1/employees/:id get 404 when employee is not found", %{conn: conn, token: token} do
    {:ok, %{employee: employee}} = EmployeeFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/employees/#{employee.id}")
                 |> json_not_found == ["Not found"]
  end

  # Returns 404 because we do not want users to know that a given id is for a valid employee
  test "GET /v1/employees/:id returns 404 when an employee does not belong to the user", %{conn: conn, token: token} do
    {:ok, %{user: other_user}} = UserFactory.create
    {:ok, %{employee: employee}} = EmployeeFactory.create(%{user_id: other_user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/employees/#{employee.id}")
                 |> json_not_found == ["Not found"]
  end

end
