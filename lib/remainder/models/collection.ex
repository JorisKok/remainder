defmodule Remainder.Collection do
  use Remainder.Schema
  import Ecto.Changeset
  alias Remainder.Project

  schema "collections" do
    field :introduction, :string
    field :name, :string

    belongs_to :project, Project

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :project_id, :introduction])
    |> validate_required([:name, :project_id])
    |> unique_constraint(:name, name: :collections_name_project_id_index)
    |> cast_assoc(:project)
    |> assoc_constraint(:project)
  end
end
