defmodule JobSiteWeb.Admin.JobsLive.ReviewSubmitComponent do
  use JobSiteWeb, :live_component

  use JobSiteWeb.VacancyFormHelpers

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="rounded-2xl border border-slate-700 bg-slate-900 p-5 shadow-lg shadow-slate-950/20 sm:p-8">
      <h1 class="text-xl font-semibold text-slate-100">Review and Submit</h1>

      <dl class="mt-6 grid gap-5 text-sm sm:grid-cols-2">
        <div>
          <dt class="text-slate-400">Job title</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.job_title}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Company ID</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.company_id}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Employment type</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.employment_type}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Experience level</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.experience_level}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Positions</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.number_of_positions}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Application deadline</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.application_deadline}</dd>
        </div>
        <div class="sm:col-span-2">
          <dt class="text-slate-400">Job summary</dt>
          <dd class="mt-1 whitespace-pre-wrap text-slate-100">{@vacancy.job_summary}</dd>
        </div>
        <div class="sm:col-span-2">
          <dt class="text-slate-400">Job description</dt>
          <dd class="mt-1 whitespace-pre-wrap text-slate-100">{@vacancy.job_description}</dd>
        </div>
        <div class="sm:col-span-2">
          <dt class="text-slate-400">Minimum qualifications</dt>
          <dd class="mt-1 text-slate-100">
            {Enum.join(@vacancy.minimum_qualifications || [], ", ")}
          </dd>
        </div>
        <div class="sm:col-span-2">
          <dt class="text-slate-400">Required skills</dt>
          <dd class="mt-1 text-slate-100">{Enum.join(@vacancy.required_skills || [], ", ")}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Work arrangement</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.work_arrangement}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Working hours</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.working_hours}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Workplace location</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.workplace_location}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Currency</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.currency}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Minimum salary</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.minimum_salary}</dd>
        </div>
        <div>
          <dt class="text-slate-400">Maximum salary</dt>
          <dd class="mt-1 text-slate-100">{@vacancy.maximum_salary}</dd>
        </div>
      </dl>

      <div class="flex justify-between border-t border-slate-700 pt-5">
        <JobVacancyComponents.back_button
          id="review-submit-back"
          previous_page_url={~p"/admin/jobs/#{@vacancy.id}/edit/?section=compensation"}
        />
        <button
          id="review-submit-button"
          phx-click={JS.push("publish_job_vacancy", target: @myself)}
          class="rounded-lg bg-slate-950 px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:cursor-pointer hover:bg-slate-800"
        >
          Publish vacancy
        </button>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def handle_event("publish_job_vacancy", _params, %{assigns: %{vacancy: vacancy}} = socket) do
    case Vacancies.publish_job_vacancy(vacancy) do
      {:ok, _vacancy} ->
        {:noreply,
         socket
         |> put_flash(:info, "The job vacancy was published")
         |> push_navigate(to: ~p"/admin/jobs")}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           "Please go back and submit all the required information to create a job vacancy"
         )
         |> push_navigate(to: ~p"/admin/jobs/#{vacancy.id}/edit?section=review_and_submit")}
    end
  end
end
