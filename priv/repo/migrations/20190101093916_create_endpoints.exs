defmodule Remainder.Repo.Migrations.CreateEndpoints do
  use Ecto.Migration

  def change do
    create table(:endpoints, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :introduction, :string
      add :request_method, :string
      add :request_url, :string
      add :request_headers, :map
      add :request_body, :map
      add :response_headers, :map
      add :response_body, :map
      add :status_code, :integer

      add :resource_id, references(:resources, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create unique_index(:endpoints, [:name, :resource_id])

  end
end
