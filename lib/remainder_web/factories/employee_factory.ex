defmodule RemainderWeb.EmployeeFactory do
  @moduledoc false
  alias Remainder.{Repo, Employee}
  alias Comeonin.Bcrypt
  alias Remainder.Guardian

  @employee %{
    email: "employee@example.com",
    password: Bcrypt.hashpwsalt("secret"),
  }

  def create do
    create_employee @employee
  end

  def create(params) do
    create_employee Map.merge(@employee, params, fn _key, value1, _value2 -> value1 end)
  end

  defp create_employee(params) do
    {:ok, employee} = Repo.insert(struct(Employee, params))
    {:ok, token, claims} = Guardian.encode_and_sign(employee)

    {:ok, %{employee: employee, token: token, claims: claims}}
  end

end
