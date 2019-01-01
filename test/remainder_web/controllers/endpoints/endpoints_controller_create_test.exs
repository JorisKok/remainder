defmodule RemainderWeb.EndpointControllerCreateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{ResourceFactory, EndpointFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    EndpointFactory.create
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
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
                 |> post(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{
                     resource.id
                   }/endpoints",
                   params
                 )
                 |> json_data == params
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints returns 401 without token", %{conn: conn, project: project, collection: collection, resource: resource} do
    params = %{
      "name" => "Endpoint X",
    }

    assert_value conn
                 |> post("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints", params)
                 |> json_auth_error == [
                   "Authorization required"
                 ]
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints returns 404 when resource is not of user",
       %{conn: conn, project: project, collection: collection, token: token} do

    {:ok, %{resource: resource}} = ResourceFactory.create

    params = %{
      "name" => "Endpoint X",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints", params)
                 |> json_not_found == ["Not found"]
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints returns 422 on missing params",
       %{conn: conn, project: project, collection: collection, resource: resource, token: token} do

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{
                     resource.id
                   }/endpoints",
                   %{}
                 )
                 |> json_validation_error == %{
                   "fields" => [
                     "name",
                     "request_url",
                     "request_method",
                     "request_headers",
                     "request_body"
                   ],
                   "messages" => [
                     "name can't be blank",
                     "request_url can't be blank",
                     "request_method can't be blank",
                     "request_headers can't be blank",
                     "request_body can't be blank"
                   ]
                 }
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints returns 422 when name + resource_id is already taken",
       %{conn: conn, project: project, user: user, collection: collection, resource: resource, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create(%{user_id: user.id, project_id: project.id, collection_id: collection.id, resource_id: resource.id})

    params = %{
      "name" => endpoint.name,
      "request_url" => "https://jsonplaceholder.typicode.com/todos/1",
      "request_method" => "POST",
      "request_body" => %{
        "age" => 50
      },
      "request_headers" => %{
        "Accept" => "application/json"
      },
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}/endpoints", params)
                 |> json_validation_error == %{
                   "fields" => ["name"],
                   "messages" => ["name has already been taken"]
                 }
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources/:resource_id/endpoints can create endpoint if name is unique for the resource, but taken for another",
       %{conn: conn, project: project, user: user, collection: collection, resource: resource, token: token} do
    {:ok, %{endpoint: endpoint}} = EndpointFactory.create(%{user_id: user.id, project_id: project.id, collection_id: collection.id, name: "Endpoint X"})

    params = %{
      "name" => endpoint.name,
      "request_url" => "https://jsonplaceholder.typicode.com/todos/1",
      "request_method" => "POST",
      "request_body" => %{
        "age" => 50
      },
      "request_headers" => %{
        "Accept" => "application/json"
      },
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{
                     resource.id
                   }/endpoints",
                   params
                 )
                 |> json_data == %{
                   "introduction" => nil,
                   "name" => endpoint.name,
                   "request_body" => %{"age" => 50},
                   "request_headers" => %{"Accept" => "application/json"},
                   "request_method" => "POST",
                   "request_url" => "https://jsonplaceholder.typicode.com/todos/1",
                   "response_body" => nil,
                   "response_headers" => nil,
                   "status_code" => nil
                 }
  end
end
