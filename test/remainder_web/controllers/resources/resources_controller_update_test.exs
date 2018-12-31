defmodule RemainderWeb.ResourceControllerUpdateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.ResourceFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    ResourceFactory.create
  end

  test "PATCH /v1/projects/:project_id/collections/:collection_id/resources/:id", %{conn: conn, project: project, collection: collection, resource: resource, token: token} do
    params = %{
      "name" => "Bob Ross Paint Resource X",
      "introduction" => "Happy painting",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{
                     resource.id
                   }",
                   params
                 )
                 |> json_data == %{
                   "introduction" => "Happy painting",
                   "name" => "Bob Ross Paint Resource X"
                 }
  end

  test "PATCH /v1/projects/:project_id/collections/:collection_id/resources/:id gets 404 when the resource does not belong to the user", %{conn: conn, project: project, collection: collection, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create()

    params = %{
      "email" => "Bob Ross Illegal Paint Resource",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}", params)
                 |> json_not_found == ["Not found"]
  end

  test "PATCH /v1/projects/:project_id/collections/:collection_id/resources/:id gets 404 when the resource does not belong to the collection", %{conn: conn, project: project, collection: collection, user: user, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create(%{project: project.id, user_id: user.id})

    params = %{
      "email" => "Bob Ross Illegal Paint Resource",
    }
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}/collections/#{collection.id}/resources/#{resource.id}", params)
                 |> json_not_found == ["Not found"]
  end
end
