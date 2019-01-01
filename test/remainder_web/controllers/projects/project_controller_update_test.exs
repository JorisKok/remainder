defmodule RemainderWeb.ProjectControllerUpdateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.ProjectFactory
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    ProjectFactory.create
  end

  test "PATCH /v1/projects/:id", %{conn: conn, project: project, token: token} do
    params = %{
      "name" => "Bob Ross Paint Project X",
    }

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}", params)
                 |> json_data == %{"name" => "Bob Ross Paint Project X"}
  end

  test "PATCH /v1/projects/:id gets 404 when the project does not belong to the user", %{conn: conn, token: token} do
    {:ok, %{project: project}} = ProjectFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}", %{})
                 |> json_not_found == ["Not found"]
  end

end
