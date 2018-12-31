defmodule Remainder.Resource do
  use Remainder.Schema
  import Ecto.Changeset
  alias Remainder.Collection


  schema "resources" do
    field :introduction, :string
    field :name, :string

    belongs_to :collection, Collection

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:name, :collection_id, :introduction])
    |> validate_required([:name, :collection_id])
    |> unique_constraint(:name, name: :resources_name_collection_id_index)
    |> cast_assoc(:collection)
    |> assoc_constraint(:collection)
  end
end
