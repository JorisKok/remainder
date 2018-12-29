defmodule Remainder.EmployeeRepo do
  alias Remainder.{Repo, Employee}
  import Remainder.Guardian
  @moduledoc false

  @doc """
  Deletes an employee that belongs to the logged in user
  """
  def delete(conn, id) do
    employee = Employee
               |> Repo.get!(id)

    case employee.user_id == me(conn).id do
      true -> Repo.delete(employee)
      false -> {:error, :unauthorized}
    end
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
