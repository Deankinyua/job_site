defmodule JobSiteWeb.Admin.JobsLive.Index do
  use JobSiteWeb, :live_view

  alias JobSite.Vacancies
  alias JobSiteWeb.Admin.JobsLive.FormComponent
  alias JobSiteWeb.Admin.JobsLive.JobVacancyComponents

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      active_tab={:jobs}
    >
      <JobVacancyComponents.jobs
        :if={@live_action == :index}
        vacancies_empty?={@vacancies_empty?}
        vacancies={@streams.job_vacancies}
      />

      <div class="flex flex-col items-center">
        <.live_component
          :if={@live_action in [:new, :edit]}
          module={FormComponent}
          id="job-vacancy-form"
          vacancy={@vacancy}
          action={@live_action}
          step_name={@step_name}
        />
      </div>
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

  @impl Phoenix.LiveView
  def handle_info({:new_job_vacancy, vacancy, current_step}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Saved")
     |> push_navigate(to: ~p"/admin/jobs/#{vacancy.id}/edit?page=#{current_step.next}")}
  end

  def handle_info({:next_step, vacancy, current_step}, socket) do
    {:noreply,
     socket
     |> assign(:vacancy, vacancy)
     |> put_flash(:info, "Saved")
     |> push_patch(to: ~p"/admin/jobs/#{vacancy.id}/edit?page=#{current_step.next}")}
  end

  defp apply_action(socket, :edit, %{"id" => id, "page" => page}) do
    socket
    |> assign(:page_title, "Edit Job Vacancy")
    |> assign(:step_name, page)
    |> assign_new(:vacancy, fn -> Vacancies.get_job_vacancy(id) end)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:vacancy, nil)
    |> assign(:page_title, "New Job Vacancy")
    |> assign(:step_name, "vacancy_details")
  end

  defp apply_action(socket, :index, _params) do
    vacancies = Vacancies.list_vacancies_for_admin()

    socket
    |> assign(:page_title, "Listing Loans")
    |> assign(:vacancies_empty?, Enum.empty?(vacancies))
    |> stream(:job_vacancies, vacancies, reset: true)
  end
end
