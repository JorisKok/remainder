defmodule RemainderWeb.ProjectControllerShowTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, ProjectFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    ProjectFactory.create
  end

  test "GET /v1/projects/:id", %{conn: conn, project: project, token: token} do

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}")
                 |> json_data == %{"name" => project.name}
  end

  test "GET /v1/projects/:id get 404 when project is not found", %{conn: conn, token: token} do
    {:ok, %{project: project}} = ProjectFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}")
                 |> json_not_found == ["Not found"]
  end

  # Returns 404 because we do not want users to know that a given id is for a valid project
  test "GET /v1/projects/:id returns 404 when an project does not belong to the user", %{conn: conn, token: token} do
    {:ok, %{user: other_user}} = UserFactory.create
    {:ok, %{project: project}} = ProjectFactory.create(%{user_id: other_user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> get("/v1/projects/#{project.id}")
                 |> json_not_found == ["Not found"]
  end

end
