defmodule RemainderWeb.TestHelper do
  use Phoenix.ConnTest
  @moduledoc """
  Contains all test helpers
  """

  @doc """
  Assert against the success data without the timestamps and the id
  """
  def json_data(conn) do
    response = json_response(conn, 200)
    case response["success"]["data"] do
      nil -> response
      data when is_map(data) -> Map.drop(data, ["id", "inserted_at", "updated_at"])
    end
  end

  @doc """
  Assert against a data count
  """
  def json_count(conn) do
    response = json_response(conn, 200)
    case response["success"]["data"] do
      nil -> response
      data when is_list(data) -> length(data)
    end
  end

  @doc """
  Asserts against authentication errors
  """
  def json_auth_error(conn) do
    response = json_response(conn, 401)
    case response["error"]["messages"] do
      nil -> response
      messages -> messages
    end
  end

  @doc """
  Assert against validation errors
  """
  def json_validation_error(conn) do
    response = json_response(conn, 422)
    case response["error"] do
      nil -> response
      errors -> errors
    end
  end

  @doc """
  Assert against a 404 not found
  """
  def json_not_found(conn) do
    response = json_response(conn, 404)
    case response["error"]["messages"] do
      nil -> response
      messages -> messages
    end
  end

  @doc """
  Assert against no response
  """
  def json_no_response(conn) do
    case conn.status == 204 do
      true -> true
      false -> conn.resp_body
    end
  end
end
