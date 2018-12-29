defmodule Remainder.Employee do
  use Remainder.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias Remainder.User
  import RemainderWeb.EmailUniqueValidator

  schema "employees" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(conn, employee, attrs) do
    new_attrs = Map.put(attrs, "user_id", Guardian.Plug.current_resource(conn).id)

    employee
    |> cast(new_attrs, [:first_name, :last_name, :email, :password, :user_id])
    |> validate_required([:first_name, :last_name, :email, :password, :user_id])
    |> cast_assoc(:user)
    |> assoc_constraint(:user)
    |> unique_constraint(:email)
    |> email_unique_users
    |> put_password_hash
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
