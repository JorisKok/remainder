defmodule Remainder.EndpointRepo do
  alias Remainder.{Repo, Endpoint}
  import Ecto.Query, only: [from: 2]
  @moduledoc false

  @doc """
  Get all the endpoints that belong to the resource
  """
  def all(conn) do
    Repo.all(from e in Endpoint, where: e.resource_id == ^conn.params["resource_id"])
  end

  @doc """
  Get the endpoint that belongs to the resource
  """
  def get(conn, id) do
    endpoint = Endpoint
                 |> Repo.get(id)
    case endpoint.resource_id == conn.params["resource_id"] do
      true -> endpoint
      false -> nil
    end
  end

  @doc """
  Updates an endpoint that belongs to the resource
  """
  def update(conn, params) do
    case get(conn, params["id"]) do
      nil -> nil
      endpoint ->
        Endpoint.changeset(endpoint, params)
        |> Repo.update
    end
  end

  @doc """
  Deletes an endpoint that belongs to the resource
  """
  def delete(conn, id) do
    Repo.delete_all(
      from e in Endpoint, where: e.resource_id == ^conn.params["resource_id"],
                            where: e.id == ^id
    )
  end

  @doc """
  Creates an endpoint that belongs to the resource
  """
  def create(params) do
    Endpoint.changeset(%Endpoint{}, params)
    |> Repo.insert()
  end
end
