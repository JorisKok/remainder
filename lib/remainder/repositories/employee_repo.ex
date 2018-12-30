defmodule Remainder.EmployeeRepo do
  alias Remainder.{Repo, Employee}
  import Remainder.Guardian
  import Ecto.Query, only: [from: 2]
  @moduledoc false

  @doc """
  Get all the employees that belong to the logged in user
  """
  def all(conn) do
    user_id = me(conn).id
    Repo.all(from e in Employee, where: e.user_id == ^user_id)
  end

  @doc """
  Deletes an employee that belongs to the logged in user
  """
  def delete(conn, id) do
    user_id = me(conn).id
    Repo.delete_all(from e in Employee, where: e.user_id == ^user_id, where: e.id == ^id)
  end

  @doc """
  Creates an employee that belongs to the logged in user
  """
  def create(conn, params) do
    attrs = Map.put(params, "user_id", me(conn).id) # Add user_id to the params
    changeset = Employee.changeset(%Employee{}, attrs)
    Repo.insert(changeset)
  end

  def get_by_email(email) do
    Employee |> Repo.get_by(email: email)
  end
end
