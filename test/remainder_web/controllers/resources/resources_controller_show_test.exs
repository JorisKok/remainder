defmodule RemainderWeb.ResourceControllerShowTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.ResourceFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    ResourceFactory.create
  end

  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:id", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}")
                 |> json_data == %{"introduction" => nil, "name" => resource.name}
  end

  # Returns 404 because we do not want users to know that a given id is for a valid resource
  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:id returns 404 when an resource does not belong to the user", %{conn: conn, project: project, collection: collection, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}")
                 |> json_not_found == ["Not found"]
  end

  # Returns 404 because we do not want users to know that a given id is for a valid resource
  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:id returns 404 when an resource does not belong to the collection", %{conn: conn, project: project, collection: collection, user: user, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create(%{user_id: user.id, project_id: project.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}")
                 |> json_not_found == ["Not found"]
  end

end
