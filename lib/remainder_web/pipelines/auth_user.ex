defmodule RemainderWeb.AuthUser do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :remainder,
    error_handler: Remainder.ErrorHandler,
    module: Remainder.Guardian

  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: false
end
