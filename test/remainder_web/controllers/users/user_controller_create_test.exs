defmodule RemainderWeb.UserControllerCreateTest do
  use RemainderWeb.ConnCase

  test "POST /v1/users", %{conn: conn} do
    conn = post(
      conn,
      "/v1/users",
      %{
        email: "create-user@example.com",
        password: "create-user-password",
        first_name: "Bob",
        last_name: "Ross",
      }
    )

    assert json_response(conn, 200) == %{
             "success" => %{
               "data" => %{
                 "email" => "create-user@example.com",
                 "first_name" => "Bob",
                 "last_name" => "Ross",
                 "company" => %{}
               }
             }
           }
  end
end
