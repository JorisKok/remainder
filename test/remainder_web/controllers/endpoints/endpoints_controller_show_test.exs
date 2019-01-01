defmodule RemainderWeb.EndpointControllerShowTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.EndpointFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    EndpointFactory.create
  end

  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints/:id", %{conn: conn, project: project, collection: collection, resource: resource, endpoint: endpoint, token: token} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{
                     resource.id
                   }/endpoints/#{endpoint.id}"
                 )
                 |> json_data == %{
                   "introduction" => endpoint.introduction,
                   "name" => endpoint.name,
                   "request_body" => endpoint.request_body,
                   "request_headers" => endpoint.request_headers,
                   "request_method" => endpoint.request_method,
                   "request_url" => endpoint.request_url,
                   "response_body" => nil,
                   "response_headers" => nil,
                   "status_code" => nil
                 }
  end

  # Returns 404 because we do not want users to know that a given id is for a valid endpoint
  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints/:id returns 404 when an endpoint does not belong to the user", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints/#{endpoint.id}")
                 |> json_not_found == ["Not found"]
  end

  # Returns 404 because we do not want users to know that a given id is for a valid endpoint
  test "GET /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints/:id returns 404 when an endpoint does not belong to the resource", %{conn: conn, project: project, collection: collection, resource: resource, user: user, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create(%{user_id: user.id, collection_id: collection.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints/#{endpoint.id}")
                 |> json_not_found == ["Not found"]
  end

end
