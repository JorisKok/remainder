defmodule Remainder.Collection do
  use Remainder.Schema
  import Ecto.Changeset
  alias Remainder.Project

  schema "collections" do
    field :introduction, :string
    field :name, :string

    belongs_to :user, User
    belongs_to :project, Project

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :user_id, :project_id])
    |> validate_required([:name, :user_id, :project_id])
    |> unique_constraint(:name, name: :collections_name_project_id_index)
    |> cast_assoc(:user)
    |> assoc_constraint(:user)
    |> cast_assoc(:project)
    |> assoc_constraint(:project)
  end
end
