defmodule RemainderWeb.EmployeeFactory do
  @moduledoc false
  alias Remainder.{Repo, Employee}
  alias Comeonin.Bcrypt
  alias Remainder.Guardian
  alias FakerElixir, as: Faker

  defp employee do
    %{
      email: Faker.Internet.email,
      password: Bcrypt.hashpwsalt("secret"),
    }
  end

  def create do
    create_employee employee()
  end

  def create(params) do
    create_employee Map.merge(employee(), params)
  end

  defp create_employee(params) do
    {:ok, employee} = Repo.insert(struct(Employee, params))

    {:ok, token, claims} = Guardian.encode_and_sign(employee)

    {:ok, %{employee: employee, token: token, claims: claims}}
  end

end
