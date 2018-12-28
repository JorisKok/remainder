defmodule RemainderWeb.UserFactory do
  @moduledoc false
  alias Remainder.{Repo, User}
  alias Comeonin.Bcrypt
  alias Remainder.Guardian

  def create_user do
    {:ok, user} = Repo.insert %User{
      email: "admin@example.com",
      password: Bcrypt.hashpwsalt("secret"),
    }

    {:ok, token, claims} = Guardian.encode_and_sign(user)

    {:ok, %{user: user, token: token, claims: claims}}
  end
end
