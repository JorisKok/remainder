defmodule RemainderWeb.CollectionControllerShowTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.CollectionFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    CollectionFactory.create
  end

  test "GET /v1/projects/:project_id/collections/:id", %{conn: conn, project: project, collection: collection, token: token} do

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}")
                 |> json_data == %{"introduction" => nil, "name" => collection.name}
  end

  # Returns 404 because we do not want users to know that a given id is for a valid collection
  test "GET /v1/projects/:project_id/collections/:id returns 404 when an collection does not belong to the user", %{conn: conn, project: project, token: token} do
    {:ok, %{collection: collection}} = CollectionFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}")
                 |> json_not_found == ["Not found"]
  end

  # Returns 404 because we do not want users to know that a given id is for a valid collection
  test "GET /v1/projects/:project_id/collections/:id returns 404 when an collection does not belong to the project", %{conn: conn, project: project, user: user, token: token} do
    {:ok, %{collection: collection}} = CollectionFactory.create(%{user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}/collections/#{collection.id}")
                 |> json_not_found == ["Not found"]
  end

end
