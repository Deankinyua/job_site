defmodule JobSiteWeb.PageController do
  use JobSiteWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/admin/jobs")
  end
end
