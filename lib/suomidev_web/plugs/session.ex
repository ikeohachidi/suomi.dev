defmodule SuomidevWeb.Plugs.Session do
  use SuomidevWeb, :controller
  import Plug.Conn
  alias Suomidev.Accounts

  def init(opts), do: opts

  def call(conn, _params) do
    session = conn |> get_session(:current_user)

    IO.inspect(session)


    if session do
      case Accounts.get_user(session.id) do
        nil ->
          conn
          |> configure_session(drop: true)
          |> put_flash(:error, "Jotain outoa tapahtui... Sori siitä.")
          |> halt()
          |> redirect(to: Routes.page_path(conn, :index))

        user ->
          conn
          |> assign(:current_user, user)
      end
    else
      conn
      |> assign(:current_user, nil)
    end
  end
end
