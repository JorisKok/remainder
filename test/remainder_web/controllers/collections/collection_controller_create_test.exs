defmodule RemainderWeb.CollectionControllerCreateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{ProjectFactory, CollectionFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    CollectionFactory.create
  end

  test "POST /v1/projects/:project_id/collections", %{conn: conn, project: project, token: token} do
    params = %{
      "name" => "Collection X",
      "introduction" => "Some introduction"
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections", params)
                 |> json_data == %{
                   "introduction" => "Some introduction",
                   "name" => "Collection X"
                 }
  end

  test "POST /v1/projects/:project_id/collections returns 401 without token", %{conn: conn, project: project} do
    params = %{
      "name" => "Collection X",
    }

    assert_value conn
                 |> post("/v1/projects/#{project.id}/collections", params)
                 |> json_auth_error == [
                   "Authorization required"
                 ]
  end

  test "POST /v1/projects/:project_id/collections returns 404 when project is not of user",
       %{conn: conn, token: token} do

    {:ok, %{project: project}} = ProjectFactory.create

    params = %{
      "name" => "Collection X",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections", params)
                 |> json_not_found == ["Not found"]
  end

  test "POST /v1/projects/:project_id/collections returns 422 on missing params",
       %{conn: conn, project: project, token: token} do

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections", %{})
                 |> json_validation_error == %{
                   "fields" => ["name"],
                   "messages" => [
                     "name can't be blank",
                   ]
                 }
  end

  test "POST /v1/collections returns 422 when name + project_id is already taken",
       %{conn: conn, user: user, project: project, token: token} do
    {:ok, %{collection: collection}} = CollectionFactory.create(%{user_id: user.id, project_id: project.id})

    params = %{
      "name" => collection.name
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections", params)
                 |> json_validation_error == %{
                   "fields" => ["name"],
                   "messages" => ["name has already been taken"]
                 }
  end

  test "POST /v1/collections can create collection if name is unique for the project, but taken for another",
       %{conn: conn, user: user, project: project, token: token} do
    {:ok, %{collection: collection}} = CollectionFactory.create(%{user_id: user.id, name: "Collection X"})

    params = %{
      "name" => collection.name
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> post("/v1/projects/#{project.id}/collections", params)
                 |> json_data == %{"introduction" => nil, "name" => "Collection X"}
  end
end
