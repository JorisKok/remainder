defmodule RemainderWeb.ProjectPipeline do
  @moduledoc """
  This pipeline makes sure that the project belongs to the logged in user
  """
  alias Remainder.ProjectRepo
  alias Remainder.Project
  use RemainderWeb, :controller

  def init(_) do
    # Such empty
  end

  def call(conn, _) do
    case ProjectRepo.get(conn, conn.params["project_id"]) do
      %Project{} = _project -> conn
      _ ->
        conn
        |> put_status(404)
        |> put_view(RemainderWeb.ErrorView)
        |> render("404.json")
        |> halt
    end
  end
end
