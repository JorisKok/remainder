defmodule RemainderWeb.ProjectControllerListTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, ProjectFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "GET /v1/projects", %{conn: conn, user: user, token: token} do
    ProjectFactory.create(%{user_id: user.id})
    ProjectFactory.create(%{user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects")
                 |> json_count == 2
  end

  test "GET /v1/projects only returns logged in user's projects", %{conn: conn, user: user, token: token} do
    {:ok, %{user: other_user}} = UserFactory.create
    ProjectFactory.create(%{user_id: user.id})
    ProjectFactory.create(%{user_id: other_user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects")
                 |> json_count == 1
  end
end
