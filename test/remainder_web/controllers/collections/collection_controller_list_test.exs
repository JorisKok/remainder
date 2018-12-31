defmodule RemainderWeb.CollectionControllerListTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.CollectionFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    CollectionFactory.create
  end

  test "GET /v1/projects/:project_id/collections", %{conn: conn, project: project, user: user, token: token} do
    CollectionFactory.create(%{project_id: project.id, user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections")
                 |> json_count == 2
  end

  test "GET /v1/projects/:project_id/collections only returns collections from the project", %{conn: conn, user: user, project: project, token: token} do
    CollectionFactory.create(%{user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections")
                 |> json_count == 1
  end

  test "GET /v1/projects/:project_id/collections only returns logged in user's collections", %{conn: conn, project: project, token: token} do
    CollectionFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections")
                 |> json_count == 1
  end
end
