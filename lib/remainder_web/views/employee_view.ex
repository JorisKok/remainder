defmodule RemainderWeb.EmployeeView do
  use RemainderWeb, :view
  alias Remainder.Employee

  def render("index.json", %{data: employees}) do
    %{
      "success" => %{
        "data" =>
          Enum.map(
            employees,
            fn employee ->
              %{
                "id" => employee.id,
                "first_name" => employee.first_name,
                "last_name" => employee.last_name,
                "email" => employee.email,
                "inserted_at" => employee.inserted_at,
                "updated_at" => employee.updated_at,
              }
            end
          )
      }
    }
  end

  def render("create.json", %{data: %Employee{} = employee}) do
    %{
      "success" => %{
        "data" => %{
          "id" => employee.id,
          "first_name" => employee.first_name,
          "last_name" => employee.last_name,
          "email" => employee.email,
          "inserted_at" => employee.inserted_at,
          "updated_at" => employee.updated_at,
        }
      }
    }
  end
end
