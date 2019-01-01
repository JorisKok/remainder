defmodule RemainderWeb.EndpointController do
  @moduledoc false
  use RemainderWeb, :controller
  alias Remainder.EndpointRepo

  def index(conn, _) do
    render conn, "success.json", data: EndpointRepo.all(conn)
  end

  def show(conn, %{"id" => id}) do
    case EndpointRepo.get(conn, id) do
      nil ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
      endpoint ->
        render conn, "success.json", data: endpoint
    end
  end

  def create(conn, params) do
    case EndpointRepo.create(params) do
      {:ok, endpoint} -> render conn, "success.json", data: endpoint
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end

  def update(conn, params) do
    case EndpointRepo.update(conn, params) do
      {:ok, endpoint} -> render conn, "success.json", data: endpoint
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
    case EndpointRepo.delete(conn, id) do
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
