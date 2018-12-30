defmodule RemainderWeb.ProjectControllerCreateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "POST /v1/projects", %{conn: conn, token: token} do
    params = %{
      "name" => "Project X",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects", params)
                 |> json_data == %{"name" => "Project X"}
  end

  test "POST /v1/projects returns 401 without token", %{conn: conn} do
    params = %{
      "name" => "Project X",
    }

    assert_value conn
                 |> post("/v1/projects", params)
                 |> json_auth_error == [
                   "Authorization required"
                 ]
  end

  test "POST /v1/projects returns 422 on missing params", %{conn: conn, token: token} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects", %{})
                 |> json_validation_error == %{
                   "fields" => ["name"],
                   "messages" => [
                     "name can't be blank",
                   ]
                 }
  end
end
