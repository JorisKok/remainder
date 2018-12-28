defmodule RemainderWeb.AuthUser do
  @moduledoc false
  use Guardian.Plug.Pipeline,
      otp_app: :remainder,
      error_handler: RemainderWeb.ErrorController,
      module: Remainder.Guardian

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.LoadResource)
  plug(Guardian.Plug.EnsureAuthenticated)
end
