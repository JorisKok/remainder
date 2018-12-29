defmodule Remainder.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password, :string
      add :company_name, :string
      add :phone, :string
      add :paid, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:email])

  end
end
