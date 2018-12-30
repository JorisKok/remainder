defmodule RemainderWeb.Router do
  use RemainderWeb, :router

  pipeline :user_auth do
    plug RemainderWeb.AuthUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", RemainderWeb do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
  end

  scope "/v1", RemainderWeb do
    pipe_through [:api, :user_auth]

    get "/secret-chocolate-bar", SecretChocolateBarController, :index
    resources "/employees", EmployeeController, only: [:index, :show, :update, :create, :delete]
    resources "/projects", ProjectController, only: [:index, :show, :update, :create, :delete]
  end
end
