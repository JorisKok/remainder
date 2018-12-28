defmodule RemainderWeb.AuthController do
  use RemainderWeb, :controller
  alias Remainder.{Repo, User}
  alias Comeonin.Bcrypt
  alias Remainder.Guardian

  def register(conn, params) do
    changeset = User.changeset(%User{}, params)
    case Repo.insert(changeset) do
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
    case authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> render("login.json", data: user, token: token)
      {:error, :invalid_credentials} ->
        render conn,
               "error.json",
               data: %{
                 error: "invalid_credentials"
               }
    end
  end

  def authenticate_user(email, plain_text_password) do
    case User
         |> Repo.get_by(email: email) do
      nil ->
        Bcrypt.dummy_checkpw()
        {:error, :invalid_credentials}
      user ->
        if Bcrypt.checkpw(plain_text_password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
