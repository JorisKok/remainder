defmodule RemainderWeb.CollectionControllerUpdateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, ProjectFactory, CollectionFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    CollectionFactory.create
  end

  test "PATCH /v1/projects/:project_id/collections/:id", %{conn: conn, project: project, collection: collection, token: token} do
    params = %{
      "name" => "Bob Ross Paint Collection X",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}/collections/#{collection.id}", params)
                 |> json_data == %{"name" => "Bob Ross Paint Collection X"}
  end

  test "PATCH /v1/collections/:id gets 404 when the collection does not belong to the user", %{conn: conn, project: project, token: token} do
    {:ok, %{user: other_user}} = UserFactory.create
    {:ok, %{collection: collection}} = CollectionFactory.create(%{user_id: other_user.id})

    params = %{
      "email" => "Bob Ross Illegal Paint Collection",
    }
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}/collections/#{collection.id}", params)
                 |> json_not_found == ["Not found"]
  end

  test "PATCH /v1/collections/:id gets 404 when the collection does not belong to the project", %{conn: conn, project: project, user: user, token: token} do
    {:ok, %{project: another_project}} = ProjectFactory.create(%{user_id: user.id})
    {:ok, %{collection: collection}} = CollectionFactory.create(%{project_id: another_project.id, user_id: user.id})

    params = %{
      "email" => "Bob Ross Illegal Paint Collection",
    }
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}/collections/#{collection.id}", params)
                 |> json_not_found == ["Not found"]
  end
end
