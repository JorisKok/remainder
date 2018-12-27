defmodule Remainder.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  # UUID's
  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :company_name, :string
    field :paid, :boolean, default: false
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :company_name, :phone])
    |> validate_required([:first_name, :last_name, :email, :password, :company_name, :phone])
    |> put_password_hash
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end