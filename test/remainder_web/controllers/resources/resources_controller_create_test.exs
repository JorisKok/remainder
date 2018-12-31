defmodule RemainderWeb.ResourceControllerCreateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{CollectionFactory, ResourceFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    ResourceFactory.create
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources", %{conn: conn, project: project, collection: collection, token: token} do
    params = %{
      "name" => "Resource X",
      "introduction" => "Some introduction",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources",
                   params
                 )
                 |> json_data == %{"introduction" => "Some introduction", "name" => "Resource X"}
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources returns 401 without token", %{conn: conn, project: project, collection: collection} do
    params = %{
      "name" => "Resource X",
    }

    assert_value conn
                 |> post("/v1/projects/#{project.id}/collections/#{collection.id}/resources", params)
                 |> json_auth_error == [
                   "Authorization required"
                 ]
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources returns 404 when collection is not of user",
       %{conn: conn, project: project, token: token} do

    {:ok, %{collection: collection}} = CollectionFactory.create

    params = %{
      "name" => "Resource X",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections/#{collection.id}/resources", params)
                 |> json_not_found == ["Not found"]
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources returns 422 on missing params",
       %{conn: conn, project: project, collection: collection, token: token} do

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections/#{collection.id}/resources", %{})
                 |> json_validation_error == %{
                   "fields" => ["name"],
                   "messages" => [
                     "name can't be blank",
                   ]
                 }
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources returns 422 when name + collection_id is already taken",
       %{conn: conn, user: user, project: project, collection: collection, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create(%{user_id: user.id, project_id: project.id, collection_id: collection.id})

    params = %{
      "name" => resource.name
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections/#{collection.id}/resources", params)
                 |> json_validation_error == %{
                   "fields" => ["name"],
                   "messages" => ["name has already been taken"]
                 }
  end

  test "POST /v1/projects/:project_id/collections/:collection_id/resources can create resource if name is unique for the collection, but taken for another",
       %{conn: conn, user: user, project: project, collection: collection, token: token} do
    {:ok, %{resource: resource}} = ResourceFactory.create(%{user_id: user.id, project_id: project.id, name: "Resource X"})

    params = %{
      "name" => resource.name
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post(
                   "/v1/projects/#{project.id}/collections/#{collection.id}/resources",
                   params
                 )
                 |> json_data == %{"introduction" => nil, "name" => "Resource X"}
  end
end
