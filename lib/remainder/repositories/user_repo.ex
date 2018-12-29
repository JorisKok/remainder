defmodule Remainder.UserRepo do
  @moduledoc false
  alias Remainder.{Repo, User, UserRepo, EmployeeRepo}
  alias Comeonin.Bcrypt
  alias Remainder.Guardian

  @doc false
  def create(params) do
    User.changeset(%User{}, params)
    |> Repo.insert
  end

  @doc false
  def get_by_email(email) do
    User |> Repo.get_by(email: email)
  end

  @doc """
  Authenticate the password for both user and/or the employee
  """
  def authenticate(email, plain_text_password) do
    case authenticate_user(email, plain_text_password) do
      {:ok, user} -> {:ok, user}
      {:error} ->
        case authenticate_employee(email, plain_text_password) do
          {:ok, employee} ->
            {:ok, employee}
          {:error} ->
            Bcrypt.dummy_checkpw()
            {:error}
        end
    end
  end

  defp authenticate_user(email, plain_text_password) do
    case UserRepo.get_by_email(email) do
      nil -> {:error}
      user -> check_password(user, plain_text_password)
    end
  end

  defp authenticate_employee(email, plain_text_password) do
    case EmployeeRepo.get_by_email(email) do
      nil -> {:error}
      employee -> check_password(employee, plain_text_password)
    end
  end

  defp check_password(resource, plain_text_password) do
    if Bcrypt.checkpw(plain_text_password, resource.password) do
      {:ok, resource}
    else
      {:error}
    end
  end
end
