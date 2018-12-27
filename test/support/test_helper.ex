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
end
