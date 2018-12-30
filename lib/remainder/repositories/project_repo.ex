defmodule Remainder.ProjectRepo do
  alias Remainder.{Repo, Project}
  import Remainder.Guardian
  import Ecto.Query, only: [from: 2]
  @moduledoc false

  @doc """
  Get all the projects that belong to the logged in user
  """
  def all(conn) do
    user_id = me(conn).id
    Repo.all(from e in Project, where: e.user_id == ^user_id)
  end

  @doc """
  Get the project that belongs to the logged in user
  """
  def get(conn, id) do
    project = Project
               |> Repo.get(id)
    case project.user_id == me(conn).id do
      true -> project
      false -> nil
    end
  end

  @doc """
  Updates an project that belongs to the logged in user
  """
  def update(conn, params) do
    case get(conn, params["id"]) do
      nil -> nil
      project ->
        Project.changeset(project, params)
        |> Repo.update
    end
  end

  @doc """
  Deletes an project that belongs to the logged in user
  """
  def delete(conn, id) do
    user_id = me(conn).id
    Repo.delete_all(from e in Project, where: e.user_id == ^user_id, where: e.id == ^id)
  end

  @doc """
  Creates an project that belongs to the logged in user
  """
  def create(conn, params) do
    attrs = Map.put(params, "user_id", me(conn).id) # Add user_id to the params
    changeset = Project.changeset(%Project{}, attrs)
    Repo.insert(changeset)
  end

  def get_by_email(email) do
    Project
    |> Repo.get_by(email: email)
  end
end
