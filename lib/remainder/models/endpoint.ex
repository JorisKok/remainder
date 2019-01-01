defmodule Remainder.Endpoint do
  use Remainder.Schema
  import Ecto.Changeset
  alias Remainder.Resource


  schema "endpoints" do
    field :name, :string
    field :introduction, :string
    field :request_url, :string
    field :request_method, :string
    field :request_headers, :map
    field :request_body, :map
    field :response_headers, :map
    field :response_body, :map
    field :status_code, :integer

    belongs_to :resource, Resource

    timestamps()
  end

  @doc false
  def changeset(endpoint, attrs) do
    endpoint
    |> cast(attrs, [:name, :introduction, :request_url, :request_method, :request_headers, :request_body, :response_headers, :response_body, :status_code, :resource_id])
    |> validate_required([:name, :request_url, :request_method, :request_headers, :request_body, :resource_id])
    |> unique_constraint(:name, name: :endpoints_name_resource_id_index)
    |> cast_assoc(:resource)
    |> assoc_constraint(:resource)
    # TODO url is valid?< even for local, or is it clients responsibility?
    # TODO check if header is in (["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"])
  end
end
