defmodule RemainderWeb.AuthView do
  use RemainderWeb, :view
  alias Remainder.User

  def render("register.json", %{data: %User{} = data}) do
    %{
      "success" => %{
        "data" => %{
          "id" => data.id,
          "first_name" => data.first_name,
          "last_name" => data.last_name,
          "email" => data.email,
          "company_name" => data.company_name,
          "phone" => data.phone,
          "inserted_at" => data.inserted_at,
          "updated_at" => data.updated_at,
          "paid" => data.paid,
        }
      }
    }
  end

  def render("login.json", %{data: %User{} = data, token: token}) do
    %{
      "success" => %{
        "data" => %{
          "token" => token,
        }
      }
    }
  end
end
