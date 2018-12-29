defmodule Remainder.Employee do
  use Remainder.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt
  alias Remainder.{Repo, User, Employee}
  import RemainderWeb.EmailUniqueValidator
  import Remainder.Guardian

  schema "employees" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string

    belongs_to :user, User

    timestamps()
  end

  @doc """
  Deletes an employee that belongs to the logged in user
  """
  def delete(conn, id) do
    employee = Employee
               |> Repo.get!(id)

    case employee.user_id == me(conn).id do
      true -> Repo.delete(employee)
      false -> {:error, :unauthorized}
    end
  end

  @doc """
  Creates an employee that belongs to the logged in user
  """
  def create(conn, params) do
    attrs = Map.put(params, "user_id", me(conn).id) # Add user_id to the params
    changeset = Employee.changeset(%Employee{}, attrs)
    Repo.insert(changeset)
  end


  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:first_name, :last_name, :email, :password, :user_id])
    |> validate_required([:first_name, :last_name, :email, :password, :user_id])
    |> cast_assoc(:user)
    |> assoc_constraint(:user)
    |> unique_constraint(:email)
    |> email_unique_users
    |> put_password_hash
  end

  defp put_password_hash(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             password: password
           }
         } = changeset
       ) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
