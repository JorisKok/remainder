defmodule RemainderWeb.ResourceControllerDeleteTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.ResourceFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    ResourceFactory.create
  end

  test "DELETE /v1/projects/:project_id/collections/:collection_id/resource/:id", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}")
                 |> json_no_response == true
  end

  test "DELETE /v1/projects/:project_id/collections/:collection_id/resource/:id cannot delete an resource if the resource belongs to a different collection", %{conn: conn, project: project, collection: collection, user: user, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create(%{user_id: user.id, project_id: project.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}")
                 |> json_not_found == ["Not found"]
  end

  test "DELETE /v1/projects/:project_id/collections/:collection_id/resource/:id cannot delete an resource of a different user", %{conn: conn, project: project, collection: collection, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}")
                 |> json_not_found == ["Not found"]
  end

end
