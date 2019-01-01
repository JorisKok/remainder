defmodule RemainderWeb.ResourcePipeline do
  @moduledoc """
  This pipeline makes sure that the resource belongs to the logged in user
  """
  alias Remainder.ResourceRepo
  alias Remainder.Resource
  use RemainderWeb, :controller

  def init(_) do
    # Such empty
  end

  def call(conn, _) do
    # TODO cache this for speed
    case ResourceRepo.get(conn, conn.params["resource_id"]) do
      %Resource{} = _resource -> conn
      _ ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
        |> halt
    end
  end
end
