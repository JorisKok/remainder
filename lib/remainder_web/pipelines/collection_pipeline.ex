defmodule RemainderWeb.CollectionPipeline do
  @moduledoc """
  This pipeline makes sure that the collection belongs to the logged in user
  """
  alias Remainder.CollectionRepo
  alias Remainder.Collection
  use RemainderWeb, :controller

  def init(_) do
    # Such empty
  end

  def call(conn, _) do
    # TODO cache this for speed
    case CollectionRepo.get(conn, conn.params["collection_id"]) do
      %Collection{} = _collection -> conn
      _ ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
        |> halt
    end
  end
end
