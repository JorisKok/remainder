defmodule RemainderWeb.AuthController do
  use RemainderWeb, :controller
  alias Remainder.{Guardian, UserRepo}

  def register(conn, params) do
    case UserRepo.create(params) do
      {:ok, user} ->
        render conn, "register.json", data: user
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_view(RemainderWeb.ErrorView)
        |> render("errors.json", data: changeset.errors)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case UserRepo.authenticate(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> render("login.json", data: user, token: token)
      {:error} ->
        conn
        |> put_view(RemainderWeb.ErrorView)
        |> render(
             "errors.json",
             data: %{
               field: "token",
               message: "Invalid Credentials"
             }
           )
    end
  end
end
