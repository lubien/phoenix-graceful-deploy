defmodule GracefulDeployWeb.HealthController do
  use GracefulDeployWeb, :controller

  def index(conn, _params) do
    if AppHealth.healthy?() do
      Plug.Conn.send_resp(conn, 200, "Ok")
    else
      Plug.Conn.send_resp(conn, 503, "Do not route here anymore")
    end
  end
end
