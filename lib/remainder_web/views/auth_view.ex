defmodule RemainderWeb.AuthView do
  use RemainderWeb, :view
  alias Remainder.{User, Employee}

  defp transform(%User{} = user) do
    %{
      "id" => user.id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "email" => user.email,
      "company_name" => user.company_name,
      "phone" => user.phone,
      "inserted_at" => user.inserted_at,
      "updated_at" => user.updated_at,
      "paid" => user.paid,
    }
  end
  
  def render("register.json", %{data: %User{} = user}) do
    %{
      "success" => %{
        "data" => transform(user)
      }
    }
  end

  def render("login.json", %{data: %User{} = _user, token: token}) do
    %{
      "success" => %{
        "data" => %{
          "token" => token,
        }
      }
    }
  end

  def render("login.json", %{data: %Employee{} = _user, token: token}) do
    %{
      "success" => %{
        "data" => %{
          "token" => token,
        }
      }
    }
  end
end
