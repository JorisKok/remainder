defmodule RemainderWeb.ResourceView do
  use RemainderWeb, :view
  alias Remainder.Resource

  defp transform(%Resource{} = resource) do
    %{
      "id" => resource.id,
      "name" => resource.name,
      "introduction" => resource.introduction,
      "inserted_at" => resource.inserted_at,
      "updated_at" => resource.updated_at,
    }
  end

  def render("success.json", %{data: %Resource{} = resource}) do
    %{
      "success" => %{
        "data" => transform(resource)
      }
    }
  end

  def render("success.json", %{data: resources}) do
    %{
      "success" => %{
        "data" =>
          Enum.map(resources, fn resource -> transform(resource) end)
      }
    }
  end
end
