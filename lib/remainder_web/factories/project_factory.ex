defmodule RemainderWeb.ProjectFactory do
  @moduledoc false
  alias Remainder.{Repo, Project}
  alias FakerElixir, as: Faker
  alias RemainderWeb.UserFactory

  defp project do
    %{
      name: Faker.App.name,
    }
  end

  def create do
    create_project project()
  end

  def create(params) do
    create_project Map.merge(project(), params)
  end

  defp create_project(params) do
    {:ok, %{user: user, token: token, claims: claims}} = create_optional_user(params)

    {:ok, project} = Repo.insert(struct(Project, Map.merge(%{user_id: user.id}, params)))

    {:ok, %{project: project, user: user, token: token, claims: claims}}
  end

  defp create_optional_user(params) do
    case Map.has_key?(params, :user_id) do
      true ->
        # When you set the user manually, you already have the user info, thus you dont need it back
        {:ok, %{user: %{id: params.user_id}, token: nil, claims: nil}}
      false ->
        UserFactory.create
    end
  end

end
