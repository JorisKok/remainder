defmodule Remainder.CollectionRepo do
  alias Remainder.{Repo, Collection}
  import Ecto.Query, only: [from: 2]
  @moduledoc false

  @doc """
  Get all the collections that belong to the project
  """
  def all(conn) do
    Repo.all(from c in Collection, where: c.project_id == ^conn.params["project_id"])
  end

  @doc """
  Get the collection that belongs to the project
  """
  def get(conn, id) do
    collection = Collection
                 |> Repo.get(id)
    case collection.project_id == conn.params["project_id"] do
      true -> collection
      false -> nil
    end
  end

  @doc """
  Updates an collection that belongs to the project
  """
  def update(conn, params) do
    case get(conn, params["id"]) do
      nil -> nil
      collection ->
        Collection.changeset(collection, params)
        |> Repo.update
    end
  end

  @doc """
  Deletes an collection that belongs to the project
  """
  def delete(conn, id) do
    Repo.delete_all(
      from c in Collection, where: c.project_id == ^conn.params["project_id"],
                            where: c.id == ^id
    )
  end

  @doc """
  Creates an collection that belongs to the project
  """
  def create(params) do
    Collection.changeset(%Collection{}, params)
    |> Repo.insert()
  end
end
