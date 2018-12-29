defmodule RemainderWeb.EmployeeController do
  @moduledoc false
  use RemainderWeb, :controller
  alias Remainder.{Repo, Employee}

  def create(conn, params) do
    changeset = Employee.changeset(conn, %Employee{}, params)
    case Repo.insert(changeset) do
      {:ok, employee} -> render conn, "create.json", data: employee
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end
end
