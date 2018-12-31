defmodule RemainderWeb.Router do
  use RemainderWeb, :router

  pipeline :user_auth do
    plug RemainderWeb.AuthUser
  end

  pipeline :belongs_to_project do
    plug RemainderWeb.ProjectPipeline
  end

  pipeline :belongs_to_collection do
    plug RemainderWeb.CollectionPipeline
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

    scope "/projects/:project_id" do
      pipe_through [:belongs_to_project]
      resources "/collections", CollectionController, only: [:index, :show, :update, :create, :delete]

      scope "/collections/:collection_id" do
        pipe_through [:belongs_to_collection]
        resources "/resources", ResourceController, only: [:index, :show, :update, :create, :delete]
      end
    end
  end
end
