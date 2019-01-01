defmodule Remainder.ResourceRepo do
  alias Remainder.{Repo, Resource}
  import Ecto.Query, only: [from: 2]
  @moduledoc false

  @doc """
  Get all the resources that belong to the collection
  """
  def all(conn) do
    Repo.all(from r in Resource, where: r.collection_id == ^conn.params["collection_id"])
  end

  @doc """
  Get the resource that belongs to the collection
  """
  def get(conn, id) do
    resource = Resource
                 |> Repo.get(id)
    case resource.collection_id == conn.params["collection_id"] do
      true -> resource
      false -> nil
    end
  end

  @doc """
  Updates an resource that belongs to the collection
  """
  def update(conn, params) do
    case get(conn, params["id"]) do
      nil -> nil
      resource ->
        Resource.changeset(resource, params)
        |> Repo.update
    end
  end

  @doc """
  Deletes an resource that belongs to the collection
  """
  def delete(conn, id) do
    Repo.delete_all(
      from r in Resource, where: r.collection_id == ^conn.params["collection_id"],
                            where: r.id == ^id
    )
  end

  @doc """
  Creates an resource that belongs to the collection
  """
  def create(params) do
    Resource.changeset(%Resource{}, params)
    |> Repo.insert()
  end
end
