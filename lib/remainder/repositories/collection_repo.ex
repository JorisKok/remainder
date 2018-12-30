defmodule Remainder.CollectionRepo do
  alias Remainder.{Repo, Collection}
  import Remainder.Guardian
  import Ecto.Query, only: [from: 2]
  @moduledoc false

  @doc """
  Get all the collections that belong to the logged in user
  """
  def all(conn) do
    user_id = me(conn).id
    Repo.all(from c in Collection, where: c.user_id == ^user_id, where: c.project_id == ^conn.params["project_id"])
  end

  @doc """
  Get the collection that belongs to the logged in user
  """
  def get(conn, id) do
    collection = Collection
                 |> Repo.get(id)
    case collection.user_id == me(conn).id do
      true -> case collection.project_id == conn.params["project_id"] do
                true -> collection
                false -> nil
              end
      false -> nil
    end
  end

  @doc """
  Updates an collection that belongs to the logged in user
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
  Deletes an collection that belongs to the logged in user
  """
  def delete(conn, id) do
    user_id = me(conn).id
    Repo.delete_all(
      from c in Collection, where: c.user_id == ^user_id,
                            where: c.project_id == ^conn.params["project_id"],
                            where: c.id == ^id
    )
  end

  @doc """
  Creates an collection that belongs to the logged in user
  """
  def create(conn, params) do
    attrs = Map.put(params, "user_id", me(conn).id) # Add user_id to the params
    changeset = Collection.changeset(%Collection{}, attrs)
    Repo.insert(changeset)
  end

  def get_by_email(email) do
    Collection
    |> Repo.get_by(email: email)
  end
end
