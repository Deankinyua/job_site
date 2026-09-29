defmodule JobSiteWeb.PageControllerTest do
  use JobSiteWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn, 302) == ~p"/admin/home"
  end
end
