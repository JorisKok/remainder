defmodule Remainder.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string # TODO unique with users?
      add :password, :string
      add :user_id, :integer

      timestamps()
    end

    create unique_index(:employees, [:email])
  end
end
