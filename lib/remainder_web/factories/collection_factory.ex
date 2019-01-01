defmodule RemainderWeb.CollectionFactory do
  @moduledoc false
  alias Remainder.{Repo, Collection}
  alias RemainderWeb.{UserFactory, ProjectFactory}
  alias FakerElixir, as: Faker

  defp collection do
    %{
      name: Faker.App.name,
    }
  end

  def create do
    create_collection collection()
  end

  def create(params) do
    create_collection Map.merge(collection(), params)
  end

  defp create_collection(params) do
    {:ok, %{user: user, token: token, claims: claims}} = create_optional_user(params)

    {:ok, %{project: project}} = create_optional_project(user, params)

    {:ok, collection} = Repo.insert(struct(Collection, Map.merge(%{project_id: project.id}, params)))

    {:ok, %{user: user, token: token, claims: claims, project: project, collection: collection}}
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

  defp create_optional_project(user, params) do
    case Map.has_key?(params, :project_id) do
      true ->
        # When you set the project manually, you already have the project info, thus you dont need it back
      {:ok, %{project: %{id: params.project_id}}}
      false ->
        ProjectFactory.create(%{user_id: user.id})
    end
  end
end
