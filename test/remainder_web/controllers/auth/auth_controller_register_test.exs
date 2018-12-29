defmodule RemainderWeb.AuthControllerRegisterTest do
  use RemainderWeb.ConnCase
  import AssertValue
  import RemainderWeb.TestHelper
  alias RemainderWeb.{UserFactory, EmployeeFactory}

  test "POST /v1/auth/register", %{conn: conn} do
    params = %{
      first_name: "Bob",
      last_name: "Ross",
      company_name: "register-company",
      phone: "06123412345",
      email: "register-user@email.com",
      password: "secret",
    }

    assert_value post(conn, "/v1/auth/register", Map.merge(params, %{password: "secret"}))
                 |> json_data == %{
                   "company_name" => "register-company",
                   "email" => "register-user@email.com",
                   "first_name" => "Bob",
                   "last_name" => "Ross",
                   "paid" => false,
                   "phone" => "06123412345"
                 }


  end

  test "POST /v1/auth/register returns 422 if missing params", %{conn: conn} do
    assert_value conn
                 |> post("/v1/auth/register")
                 |> json_validation_error == %{
                   "fields" => [
                     "first_name",
                     "last_name",
                     "email",
                     "password",
                     "company_name",
                     "phone"
                   ],
                   "messages" => [
                     "first_name can't be blank",
                     "last_name can't be blank",
                     "email can't be blank",
                     "password can't be blank",
                     "company_name can't be blank",
                     "phone can't be blank"
                   ]
                 }
  end

  test "POST /v1/auth/register returns 422 if email is already taken", %{conn: conn} do
    {:ok, %{user: user}} = UserFactory.create

    params = %{
      first_name: "Bob",
      last_name: "Ross",
      company_name: "register-company",
      phone: "06123412345",
      email: user.email,
      password: "secret",
    }
    assert_value conn
                 |> post("/v1/auth/register", params)
                 |> json_validation_error == %{
                   "fields" => ["email"],
                   "messages" => ["email has already been taken"]
                 }
  end

  test "POST /v1/auth/register returns 422 if email is already taken by an employee", %{conn: conn} do
    {:ok, %{employee: employee}} = EmployeeFactory.create

    params = %{
      first_name: "Bob",
      last_name: "Ross",
      company_name: "register-company",
      phone: "06123412345",
      email: employee.email,
      password: "secret",
    }

    assert_value conn
                 |> post("/v1/auth/register", params)
                 |> json_validation_error == %{
                   "fields" => ["email"],
                   "messages" => ["email already exists"]
                 }
  end
end
