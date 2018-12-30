defmodule RemainderWeb.ProjectControllerUpdateTest do
  use RemainderWeb.ConnCase
  alias RemainderWeb.{UserFactory, ProjectFactory}
  import AssertValue
  import RemainderWeb.TestHelper

  setup do
    UserFactory.create
  end

  test "PATCH /v1/projects/:id", %{conn: conn, user: user, token: token} do
    {:ok, %{project: project}} = ProjectFactory.create(%{user_id: user.id})

    params = %{
      "name" => "Bob Ross Paint Project X",
    }
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}", params)
                 |> json_data == %{"name" => "Bob Ross Paint Project X"}
  end

  test "PATCH /v1/projects/:id gets 404 when the project does not belong to the user", %{conn: conn, token: token} do
    {:ok, %{user: other_user}} = UserFactory.create
    {:ok, %{project: project}} = ProjectFactory.create(%{user_id: other_user.id})

    params = %{
      "email" => "Bob Ross Illegal Paint Project",
    }
    assert_value conn
                 |> put_req_header("authorization", "Bearer: #{token}")
                 |> patch("/v1/projects/#{project.id}", params)
                 |> json_not_found == ["Not found"]
  end

end
