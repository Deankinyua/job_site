defmodule JobSiteWeb.Admin.JobsLive.Index do
  use JobSiteWeb, :live_view

  alias JobSite.Vacancies

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      active_tab={:jobs}
    >
    </Layouts.app>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, stream_configure(socket, :job_vacancies, dom_id: &"job-vacancy-#{&1.id}")}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id, "section" => section}) do
    vacancy = Vacancies.get_job_vacancy(id)

    socket
    |> assign(:page_title, "Edit Job Vacancy")
    |> assign(:step_name, section)
    |> assign(:vacancy, vacancy)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:vacancy, nil)
    |> assign(:page_title, "New Job Vacancy")
    |> assign(:step_name, "applicant_details")
  end

  defp apply_action(socket, :index, _params) do
    vacancies = Vacancies.list_vacancies_for_admin()

    socket
    |> assign(:page_title, "Listing Loans")
    |> assign(:vacancies_empty?, Enum.empty?(vacancies))
    |> stream(:job_vacancies, vacancies, reset: true)
  end
end
