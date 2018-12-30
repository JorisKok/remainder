defmodule RemainderWeb.EmployeeView do
  use RemainderWeb, :view
  alias Remainder.Employee

  defp transform(%Employee{} = employee) do
    %{
      "id" => employee.id,
      "first_name" => employee.first_name,
      "last_name" => employee.last_name,
      "email" => employee.email,
      "inserted_at" => employee.inserted_at,
      "updated_at" => employee.updated_at,
    }
  end

  def render("success.json", %{data: %Employee{} = employee}) do
    %{
      "success" => %{
        "data" => transform(employee)
      }
    }
  end

  def render("success.json", %{data: employees}) do
    %{
      "success" => %{
        "data" =>
          Enum.map(employees, fn employee -> transform(employee) end)
      }
    }
  end
end
