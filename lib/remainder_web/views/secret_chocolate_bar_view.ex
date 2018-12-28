defmodule RemainderWeb.SecretChocolateBarView do
  use RemainderWeb, :view

  def render("index.json", _) do
    %{
      "success" => %{
        "data" => %{
          "message" => "You found it!"
        }
      }
    }
  end
end
