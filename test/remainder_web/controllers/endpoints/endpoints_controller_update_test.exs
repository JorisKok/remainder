defmodule RemainderWeb.EndpointControllerUpdateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.EndpointFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    EndpointFactory.create
  end

  test "PATCH /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints/:id", %{conn: conn, project: project, collection: collection, resource: resource, endpoint: endpoint, token: token} do
    params = %{
      "name" => "Endpoint X",
      "introduction" => "Some introduction",
      "request_url" => "https://jsonplaceholder.typicode.com/todos/1",
      "request_method" => "POST",
      "request_body" => %{"age" => 50},
      "request_headers" => %{"Accept" => "application/json"},
      "response_headers" => %{"Content-Type" => "application/json; charset=UTF-8"},
      "response_body" => %{"age" => 50},
      "status_code" => 200,
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{
                     resource.id
                   }/endpoints/#{endpoint.id}",
                   params
                 )
                 |> json_data == %{
                   "introduction" => "Some introduction",
                   "name" => "Endpoint X",
                   "request_body" => %{"age" => 50},
                   "request_headers" => %{"Accept" => "application/json"},
                   "request_method" => "POST",
                   "request_url" => "https://jsonplaceholder.typicode.com/todos/1",
                   "response_body" => %{"age" => 50},
                   "response_headers" => %{"Content-Type" => "application/json; charset=UTF-8"},
                   "status_code" => 200
                 }
  end

  test "PATCH /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints/:id gets 404 when the endpoint does not belong to the user", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints/#{endpoint.id}", %{})
                 |> json_not_found == ["Not found"]
  end

  test "PATCH /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints/:id gets 404 when the endpoint does not belong to the resource", %{conn: conn, project: project, collection: collection, resource: resource, user: user, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create(%{project_id: project.id, collection_id: collection.id, user_id: user.id})

    params = %{
      "email" => "Bob Ross Illegal Paint Endpoint",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints/#{endpoint.id}", params)
                 |> json_not_found == ["Not found"]
  end
end
