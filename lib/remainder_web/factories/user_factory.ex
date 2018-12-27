defmodule RemainderWeb.UserFactory do
  @moduledoc false
  alias Remainder.{Repo, User}
  alias Comeonin.Bcrypt

  def create_user do
    Repo.insert %User{
      email: "admin@example.com",
      password: Bcrypt.hashpwsalt("secret"),
    }
  end
end
