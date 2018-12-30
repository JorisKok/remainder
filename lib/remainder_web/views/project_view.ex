defmodule RemainderWeb.ProjectView do
  use RemainderWeb, :view
  alias Remainder.Project

  defp transform(%Project{} = project) do
    %{
      "id" => project.id,
      "name" => project.name,
      "inserted_at" => project.inserted_at,
      "updated_at" => project.updated_at,
    }
  end

  def render("success.json", %{data: %Project{} = project}) do
    %{
      "success" => %{
        "data" => transform(project)
      }
    }
  end

  def render("success.json", %{data: projects}) do
    %{
      "success" => %{
        "data" =>
          Enum.map(projects, fn project -> transform(project) end)
      }
    }
  end
end
