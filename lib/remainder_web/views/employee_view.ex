defmodule RemainderWeb.EmployeeView do
  use RemainderWeb, :view
  alias Remainder.Employee

  def render("create.json", %{data: %Employee{} = data}) do
    %{
      "success" => %{
        "data" => %{
          "id" => data.id,
          "first_name" => data.first_name,
          "last_name" => data.last_name,
          "email" => data.email,
          "inserted_at" => data.inserted_at,
          "updated_at" => data.updated_at,
        }
      }
    }
  end
end
