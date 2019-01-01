defmodule RemainderWeb.EndpointFactory do
  @moduledoc false
  alias Remainder.{Repo, Endpoint}
  alias RemainderWeb.{UserFactory, ProjectFactory, CollectionFactory, ResourceFactory}
  alias FakerElixir, as: Faker

  defp endpoint do
    %{
      name: Faker.App.name,
      introduction: Faker.App.name,
      request_method: Faker.Helper.pick(["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"]),
      request_url: Faker.Internet.url(),
      request_headers: %{"Accept" => "application/json"},
      request_body: %{"name" => Faker.App.name},
    }
  end

  def create do
    create_endpoint endpoint()
  end

  def create(params) do
    create_endpoint Map.merge(endpoint(), params)
  end

  defp create_endpoint(params) do
    {:ok, %{user: user, token: token, claims: claims}} = create_optional_user(params)

    {:ok, %{project: project}} = create_optional_project(user, params)

    {:ok, %{collection: collection}} = create_optional_collection(user, project, params)

    {:ok, %{resource: resource}} = create_optional_resource(user, project, collection, params)

    {:ok, endpoint} = Repo.insert(struct(Endpoint, Map.merge(%{resource_id: resource.id}, params)))

    {:ok, %{user: user, token: token, claims: claims, project: project, collection: collection, resource: resource, endpoint: endpoint}}
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

  defp create_optional_resource(user, project, collection, params) do
    case Map.has_key?(params, :resource_id) do
      true ->
        # When you set the project manually, you already have the project info, thus you dont need it back
        {:ok, %{resource: %{id: params.resource_id}}}
      false ->
        ResourceFactory.create(%{user_id: user.id, project_id: project.id, collection_id: collection.id})
    end
  end
end
