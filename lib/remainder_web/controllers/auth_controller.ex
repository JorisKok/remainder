defmodule RemainderWeb.AuthController do
  use RemainderWeb, :controller
  alias Remainder.{Repo, User, Employee}
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
    case authenticate(email, password) do
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


  defp authenticate(email, plain_text_password) do
    case authenticate_user(email, plain_text_password) do
      {:ok, user} -> {:ok, user}
      {:error} ->
        case authenticate_employee(email, plain_text_password) do
          {:ok, employee} ->
            {:ok, employee}
          {:error} ->
            Bcrypt.dummy_checkpw()
            {:error}
        end
    end
  end

  defp authenticate_user(email, plain_text_password) do
    case User
         |> Repo.get_by(email: email) do
      nil -> {:error}
      user -> check_password(user, plain_text_password)
    end
  end

  defp authenticate_employee(email, plain_text_password) do
    case Employee
         |> Repo.get_by(email: email) do
      nil -> {:error}
      employee -> check_password(employee, plain_text_password)
    end
  end

  defp check_password(resource, plain_text_password) do
    if Bcrypt.checkpw(plain_text_password, resource.password) do
      {:ok, resource}
    else
      {:error}
    end
  end

end
