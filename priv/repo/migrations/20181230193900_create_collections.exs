defmodule Remainder.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :introduction, :text
      add :project_id, references(:projects, on_delete: :nothing, type: :uuid)
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create unique_index(:collections, [:name, :project_id])
  end
end
