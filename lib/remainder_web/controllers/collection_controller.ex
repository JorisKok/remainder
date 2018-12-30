defmodule RemainderWeb.CollectionController do
  @moduledoc false
  use RemainderWeb, :controller
  alias Remainder.{CollectionRepo}

  def index(conn, _) do
    render conn, "success.json", data: CollectionRepo.all(conn)
  end

  def show(conn, %{"id" => id}) do
    case CollectionRepo.get(conn, id) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
      collection ->
        render conn, "success.json", data: collection
    end
  end

  def create(conn, params) do
    case CollectionRepo.create(params) do
      {:ok, collection} -> render conn, "success.json", data: collection
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end

  def update(conn, params) do
    case CollectionRepo.update(conn, params) do
      {:ok, collection} -> render conn, "success.json", data: collection
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
    case CollectionRepo.delete(conn, id) do
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
