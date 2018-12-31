defmodule RemainderWeb.ResourceController do
  @moduledoc false
  use RemainderWeb, :controller
  alias Remainder.{ResourceRepo}

  def index(conn, _) do
    render conn, "success.json", data: ResourceRepo.all(conn)
  end

  def show(conn, %{"id" => id}) do
    case ResourceRepo.get(conn, id) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
      resource ->
        render conn, "success.json", data: resource
    end
  end

  def create(conn, params) do
    case ResourceRepo.create(params) do
      {:ok, resource} -> render conn, "success.json", data: resource
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end

  def update(conn, params) do
    case ResourceRepo.update(conn, params) do
      {:ok, resource} -> render conn, "success.json", data: resource
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
    case ResourceRepo.delete(conn, id) do
      {1, _} ->
        conn
        |> put_status(204)
      {0, _} ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
    end
  end
end
