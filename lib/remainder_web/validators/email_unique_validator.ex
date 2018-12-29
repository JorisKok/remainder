defmodule RemainderWeb.EmailUniqueValidator do
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Remainder.Repo

  @moduledoc """
  Checks whether the email is unique over another table
  """

  @doc """
  Is the email unique for the users
  """
  def email_unique_users(changeset) do
    email_unique(changeset, "users")
  end

  @doc """
  Is the email unique for the employees
  """
  def email_unique_employees(changeset) do
    email_unique(changeset, "employees")
  end

  @doc false
  defp email_unique(changeset, table) do
    value = get_field(changeset, :email)
    case value do
      nil -> changeset
      _ ->
        query = from t in table,
                     where: t.email == ^value,
                     select: t.id

        case Repo.exists?(query) do
          true -> add_error(changeset, :email, "already exists")
          false -> changeset
        end
    end
  end

end
