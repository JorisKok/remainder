defmodule RemainderWeb.EmployeeController do
  @moduledoc false
  use RemainderWeb, :controller
  alias Remainder.{EmployeeRepo}

  def index(conn, _) do
    render conn, "success.json", data: EmployeeRepo.all(conn)
  end

  def show(conn, %{"id" => id}) do
    case EmployeeRepo.get(conn, id) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
      employee ->
        render conn, "success.json", data: employee
    end
  end

  def create(conn, params) do
    case EmployeeRepo.create(conn, params) do
      {:ok, employee} -> render conn, "success.json", data: employee
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end

  def update(conn, params) do
    case EmployeeRepo.update(conn, params) do
      {:ok, employee} -> render conn, "success.json", data: employee
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
      nil ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    case EmployeeRepo.delete(conn, id) do
      {1, _} ->
        conn
        |> put_status(204)
      {0, _} ->
        conn
        |> put_status(401)
        |> put_view(RemainderWeb.ErrorView)
        |> render("auth_error.json")
    end
  end
end
