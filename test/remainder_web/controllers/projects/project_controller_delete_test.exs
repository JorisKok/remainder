defmodule RemainderWeb.ProjectControllerDeleteTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, ProjectFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "DELETE /v1/project/:id", %{conn: conn, user: user, token: token} do
    {:ok, %{project: project}} = ProjectFactory.create(%{user_id: user.id})

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}")
                 |> json_no_response == true
  end

  test "DELETE /v1/project/:id cannot delete an project of a different user", %{conn: conn, token: token} do
    {:ok, %{project: project}} = ProjectFactory.create

    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> delete("/v1/projects/#{project.id}")
                 |> json_auth_error == ["Authorization required"]
  end

end
