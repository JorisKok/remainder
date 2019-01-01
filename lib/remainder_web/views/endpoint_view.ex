defmodule RemainderWeb.EndpointView do
  use RemainderWeb, :view
  alias Remainder.Endpoint

  defp transform(%Endpoint{} = endpoint) do
    %{
      "id" => endpoint.id,
      "name" => endpoint.name,
      "introduction" => endpoint.introduction,
      "request_url" => endpoint.request_url,
      "request_headers" => endpoint.request_headers,
      "request_body" => endpoint.request_body,
      "request_method" => endpoint.request_method,
      "response_headers" => endpoint.response_headers,
      "response_body" => endpoint.response_body,
      "status_code" => endpoint.status_code,
      "inserted_at" => endpoint.inserted_at,
      "updated_at" => endpoint.updated_at,
    }
  end

  def render("success.json", %{data: %Endpoint{} = endpoint}) do
    %{
      "success" => %{
        "data" => transform(endpoint)
      }
    }
  end

  def render("success.json", %{data: endpoints}) do
    %{
      "success" => %{
        "data" =>
          Enum.map(endpoints, fn endpoint -> transform(endpoint) end)
      }
    }
  end
end
