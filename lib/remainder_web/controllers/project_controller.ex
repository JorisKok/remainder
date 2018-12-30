defmodule RemainderWeb.ProjectController do
  @moduledoc false
  use RemainderWeb, :controller
  alias Remainder.{ProjectRepo}

  def index(conn, _) do
    render conn, "success.json", data: ProjectRepo.all(conn)
  end

  def show(conn, %{"id" => id}) do
    case ProjectRepo.get(conn, id) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
      project ->
        render conn, "success.json", data: project
    end
  end

  def create(conn, params) do
    case ProjectRepo.create(conn, params) do
      {:ok, project} -> render conn, "success.json", data: project
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end

  def update(conn, params) do
    case ProjectRepo.update(conn, params) do
      {:ok, project} -> render conn, "success.json", data: project
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
    case ProjectRepo.delete(conn, id) do
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
