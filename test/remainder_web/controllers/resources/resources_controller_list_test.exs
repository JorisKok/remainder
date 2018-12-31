defmodule RemainderWeb.ResourceControllerListTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.ResourceFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    ResourceFactory.create
  end

  test "GET /v1/projects/:project_id/collections/:collection_id/resources", %{conn: conn, project: project, collection: collection, user: user, token: token} do
    ResourceFactory.create(%{project_id: project.id, collection_id: collection.id, user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources")
                 |> json_count == 2
  end

  test "GET /v1/projects/:project_id/collections/:collection_id/resources only returns resources from the collection", %{conn: conn, project: project, user: user, collection: collection, token: token} do
    ResourceFactory.create(%{user_id: user.id, project_id: project.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources")
                 |> json_count == 1
  end

  @tag :current
  test "GET /v1/projects/:project_id/collections/:collection_id/resources only returns logged in user's resources", %{conn: conn, project: project, collection: collection, token: token} do
    ResourceFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources")
                 |> json_count == 1
  end
end
