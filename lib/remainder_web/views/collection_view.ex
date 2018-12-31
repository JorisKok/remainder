defmodule RemainderWeb.CollectionView do
  use RemainderWeb, :view
  alias Remainder.Collection

  defp transform(%Collection{} = collection) do
    %{
      "id" => collection.id,
      "name" => collection.name,
      "introduction" => collection.introduction,
      "inserted_at" => collection.inserted_at,
      "updated_at" => collection.updated_at,
    }
  end

  def render("success.json", %{data: %Collection{} = collection}) do
    %{
      "success" => %{
        "data" => transform(collection)
      }
    }
  end

  def render("success.json", %{data: collections}) do
    %{
      "success" => %{
        "data" =>
          Enum.map(collections, fn collection -> transform(collection) end)
      }
    }
  end
end
