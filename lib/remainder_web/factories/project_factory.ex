defmodule RemainderWeb.ProjectFactory do
  @moduledoc false
  alias Remainder.{Repo, Project}
  alias FakerElixir, as: Faker

  defp project do
    %{
      name: Faker.App.name,
    }
  end

  def create do
    create_project project()
  end

  def create(params) do
    create_project Map.merge(params, project(), fn _key, value1, _value2 -> value1 end)
  end

  defp create_project(params) do
    {:ok, project} = Repo.insert(struct(Project, params))

    {:ok, %{project: project}}
  end

end
