defmodule RemainderWeb.EmployeeController do
  @moduledoc false
  use RemainderWeb, :controller
  alias Remainder.{Repo, Employee}

  def create(conn, params) do
    case Employee.create(conn, params) do
      {:ok, employee} -> render conn, "create.json", data: employee
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Employee.delete(conn, id)do
      {:ok, _employee} ->
        conn
        |> put_status(204)
      {:error, :unauthorized} ->
        conn
        |> put_status(401)
        |> put_view(RemainderWeb.ErrorView)
        |> render("auth_error.json")
    end
  end
end
