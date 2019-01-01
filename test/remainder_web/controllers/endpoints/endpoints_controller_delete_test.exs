defmodule RemainderWeb.EndpointControllerDeleteTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.EndpointFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    EndpointFactory.create
  end

  test "DELETE /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoint/:id", %{conn: conn, project: project,  collection: collection, resource: resource, endpoint: endpoint, token: token} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints/#{endpoint.id}")
                 |> json_no_response == true
  end

  test "DELETE /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoint/:id cannot delete an endpoint if the endpoint belongs to a different resource", %{conn: conn, project: project, collection: collection, resource: resource, user: user, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create(%{user_id: user.id, project_id: project.id, collection_id: collection.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints/#{endpoint.id}")
                 |> json_not_found == ["Not found"]
  end

  test "DELETE /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoint/:id cannot delete an endpoint of a different user", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints/#{endpoint.id}")
                 |> json_not_found == ["Not found"]
  end

end
