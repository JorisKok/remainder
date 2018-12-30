defmodule Remainder.Project do
  use Remainder.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name, name: :projects_name_user_id_index)
    |> cast_assoc(:user)
    |> assoc_constraint(:user)
  end
end
