defmodule RemainderWeb.UserFactory do
  @moduledoc false
  alias Remainder.{Repo, User}
  alias Comeonin.Bcrypt
  alias Remainder.Guardian
  alias FakerElixir, as: Faker

  defp user do
    %{
      email: Faker.Internet.email,
      password: Bcrypt.hashpwsalt("secret"),
    }
  end

  def create do
    create_user user()
  end

  defp create_user(params) do
    {:ok, user} = Repo.insert(struct(User, params))

    {:ok, token, claims} = Guardian.encode_and_sign(user)

    {:ok, %{user: user, token: token, claims: claims}}
  end
end
