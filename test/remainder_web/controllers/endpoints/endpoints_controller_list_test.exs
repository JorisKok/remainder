defmodule RemainderWeb.EndpointControllerListTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.EndpointFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    EndpointFactory.create
  end

  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints", %{conn: conn, project: project, collection: collection, resource: resource, user: user, token: token} do
    EndpointFactory.create(%{project_id: project.id, collection_id: collection.id, resource_id: resource.id, user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints")
                 |> json_count == 2
  end

  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints only returns endpoints from the resource", %{conn: conn, project: project, collection: collection, user: user, resource: resource, token: token} do
    EndpointFactory.create(%{project_id: project.id, user_id: user.id, collection_id: collection.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints")
                 |> json_count == 1
  end

  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints only returns logged in user's endpoints", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
    EndpointFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints")
                 |> json_count == 1
  end
end
