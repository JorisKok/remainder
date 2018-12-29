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
      data -> Map.drop(data, ["id", "inserted_at", "updated_at"])
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
      messages -> messages
    end
  end

  @doc """
  Assert against no response
  """
  def json_no_response(conn) do
    conn.status == 204
  end
end
