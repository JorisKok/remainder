defmodule RemainderWeb.EmployeeControllerCreateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, EmployeeFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "POST /v1/employee", %{conn: conn, token: token} do
    params = %{
      "first_name" => "Jane",
      "last_name" => "Doe",
      "email" => "employee@example.com",
      "password" => "secret",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/employees", params)
                 |> json_data == %{
                   "email" => "employee@example.com",
                   "first_name" => "Jane",
                   "last_name" => "Doe"
                 }
  end

  test "POST /v1/employee returns 401 without token", %{conn: conn} do
    params = %{
      "first_name" => "Jane",
      "last_name" => "Doe",
      "email" => "employee@example.com",
      "password" => "secret",
    }

    assert_value conn
                 |> post("/v1/employees", params)
                 |> json_auth_error == [
                   "Authorization required"
                 ]
  end

  test "POST /v1/employees returns 422 on missing params", %{conn: conn, token: token} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/employees", %{})
                 |> json_validation_error == %{
                   "fields" => ["first_name", "last_name", "email", "password"],
                   "messages" => [
                     "first_name can't be blank",
                     "last_name can't be blank",
                     "email can't be blank",
                     "password can't be blank"
                   ]
                 }
  end


  test "POST /v1/employee cant create an employee when email exists", %{conn: conn, token: token} do
    {:ok, %{employee: employee}} = EmployeeFactory.create

    params = %{
      "first_name" => "Jane",
      "last_name" => "Doe",
      "email" => employee.email,
      "password" => "secret",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/employees", params)
                 |> json_validation_error == %{
                   "fields" => ["email"],
                   "messages" => ["email has already been taken"]
                 }
  end

  test "POST /v1/employee cant create an employee when email exists in users", %{conn: conn, user: user, token: token} do
    params = %{
      "first_name" => "Jane",
      "last_name" => "Doe",
      "email" => user.email,
      "password" => "secret",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/employees", params)
                 |> json_validation_error == %{
                   "fields" => ["email"],
                   "messages" => ["email already exists"]
                 }
  end
end
