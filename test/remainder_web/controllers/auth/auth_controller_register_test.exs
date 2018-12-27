defmodule RemainderWeb.AuthControllerRegisterTest do
  use RemainderWeb.ConnCase
  import AssertValue
  import RemainderWeb.TestHelper

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
end
