defmodule RemainderWeb.EmployeeFactory do
  @moduledoc false
  alias Remainder.{Repo, Employee}
  alias Comeonin.Bcrypt
  alias Remainder.Guardian

  def create do
    {:ok, employee} = Repo.insert %Employee{
      email: "employee@example.com",
      password: Bcrypt.hashpwsalt("secret"),
    }

    {:ok, token, claims} = Guardian.encode_and_sign(employee)

    {:ok, %{employee: employee, token: token, claims: claims}}
  end
end
