defmodule RemainderWeb.CollectionControllerDeleteTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{CollectionFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    CollectionFactory.create
  end

  test "DELETE /v1/projects/:project_id/collection/:id", %{conn: conn, project: project, collection: collection, token: token} do
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}")
                 |> json_no_response == true
  end

  test "DELETE /v1/projects/:project_id/collection/:id cannot delete an collection if the collection belongs to a different project", %{conn: conn, project: project, user: user, token: token} do
    {:ok, %{collection: collection}} = CollectionFactory.create(%{user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}")
                 |> json_not_found == ["Not found"]
  end

  test "DELETE /v1/projects/:project_id/collection/:id cannot delete an collection of a different user", %{conn: conn, project: project, token: token} do
    {:ok, %{collection: collection}} = CollectionFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}/collections/#{collection.id}")
                 |> json_not_found == ["Not found"]
  end

end
