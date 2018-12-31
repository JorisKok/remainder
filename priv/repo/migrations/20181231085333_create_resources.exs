defmodule Remainder.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :introduction, :text
      add :collection_id, references(:collections, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create unique_index(:resources, [:name, :collection_id])
  end
end
