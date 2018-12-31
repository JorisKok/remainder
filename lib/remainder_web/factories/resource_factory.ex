defmodule RemainderWeb.ResourceFactory do
  @moduledoc false
  alias Remainder.{Repo, Resource}
  alias RemainderWeb.{UserFactory, ProjectFactory, CollectionFactory}
  alias FakerElixir, as: Faker

  defp resource do
    %{
      name: Faker.App.name,
    }
  end

  def create do
    create_resource resource()
  end

  def create(params) do
    create_resource Map.merge(resource(), params)
  end

  defp create_resource(params) do
    {:ok, %{user: user, token: token, claims: claims}} = create_optional_user(params)

    {:ok, %{project: project}} = create_optional_project(user, params)

    {:ok, %{collection: collection}} = create_optional_collection(user, project, params)

    {:ok, resource} = Repo.insert(struct(Resource, Map.merge(%{project_id: project.id, collection_id: collection.id, user_id: user.id}, params)))

    {:ok, %{user: user, token: token, claims: claims, project: project, collection: collection, resource: resource}}
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

  defp create_optional_collection(user, project, params) do
    case Map.has_key?(params, :collection_id) do
      true ->
        # When you set the project manually, you already have the project info, thus you dont need it back
        {:ok, %{collection: %{id: params.collection_id}}}
      false ->
        CollectionFactory.create(%{user_id: user.id, project_id: project.id})
    end
  end
end
