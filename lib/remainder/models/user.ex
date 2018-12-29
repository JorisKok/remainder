defmodule Remainder.User do
  use Remainder.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  import RemainderWeb.EmailUniqueValidator
  @moduledoc """
  The user is the main account of a company
  When a user has paid, it can create employees
  Employees can also login and create resources
  All resources are linked to a user
  """

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
    |> unique_constraint(:email)
    |> email_unique_employees
    |> put_password_hash
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
