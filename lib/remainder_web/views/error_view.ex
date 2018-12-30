defmodule RemainderWeb.ErrorView do
  use RemainderWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("404.json", %{}) do
    %{
      "error" => %{
        "fields" => ["id"],
        "messages" => ["Not found"]
      }
    }
  end

  def render("auth_error.json", %{}) do
    %{
      "error" => %{
        "fields" => ["token"],
        "messages" => ["Authorization required"]
      }
    }
  end

  def render("errors.json", %{data: %{field: field, message: message}}) do
    %{
      "error" => %{
        "fields" => [field],
        "messages" => [message]
      }
    }
  end

  def render("errors.json", %{data: data}) do
    %{
      "error" => %{
        "fields" => Enum.map(data, fn {key, {_, _}} -> key end),
        "messages" => Enum.map(data, fn {key, {message, _}} -> "#{key} #{message}" end),
      }
    }
  end
end
