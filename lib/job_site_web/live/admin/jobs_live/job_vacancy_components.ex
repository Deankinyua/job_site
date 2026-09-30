defmodule JobSiteWeb.Admin.JobsLive.JobVacancyComponents do
  @moduledoc """
  Dead components used in the job vacancy multi-step form
  """

  use JobSiteWeb, :html

  @type assigns :: map()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  attr :steps, :list, required: true
  attr :current_step, JobSiteWeb.Step, required: true

  @spec stepper(assigns()) :: rendered()
  def stepper(assigns) do
    assigns =
      assign(assigns,
        titles: Enum.map(assigns.steps, &step_title(&1.name)),
        current_step_number:
          (Enum.find_index(assigns.steps, &(&1.name == assigns.current_step.name)) ||
             0) +
            1
      )

    ~H"""
    <nav
      id={"grant-application-stepper-#{@current_step.name}"}
      phx-hook="ScrollIntoView"
      aria-label="Form progress"
      class="min-w-0 rounded-2xl border border-slate-200 bg-white p-3 shadow-sm sm:p-4"
    >
      <div class="mb-4 flex flex-wrap items-center justify-between gap-2 px-1">
        <p class="text-xs font-semibold uppercase tracking-widest text-slate-500">
          Create a vacancy
        </p>
        <p class="text-xs font-medium text-indigo-700">
          Step {@current_step_number} of {length(@titles)}
        </p>
      </div>
      <ol class="grid min-w-0 grid-cols-1 gap-2 sm:grid-cols-5">
        <li
          :for={{title, step_number} <- Enum.with_index(@titles, 1)}
          id={"job-vacancy-step-#{step_number}"}
          aria-current={if step_number == @current_step_number, do: "step"}
          class={[
            "flex min-w-0 items-center gap-3 rounded-xl border p-3 transition-colors duration-200 sm:flex-col sm:gap-2 sm:px-2 sm:py-4 sm:text-center",
            step_number < @current_step_number && "border-teal-100 bg-teal-50 text-teal-800",
            step_number == @current_step_number &&
              "border-indigo-200 bg-indigo-50 text-indigo-950 ring-1 ring-indigo-200",
            step_number > @current_step_number && "border-slate-100 bg-slate-50 text-slate-500"
          ]}
        >
          <span
            aria-hidden="true"
            class={[
              "flex size-8 shrink-0 items-center justify-center rounded-full text-xs font-semibold",
              step_number < @current_step_number && "bg-teal-600 text-white",
              step_number == @current_step_number && "bg-indigo-600 text-white shadow-sm",
              step_number > @current_step_number && "bg-slate-200 text-slate-500"
            ]}
          >
            <%= if step_number < @current_step_number do %>
              <.icon name="hero-check" class="size-4" />
            <% else %>
              {step_number}
            <% end %>
          </span>
          <span class="min-w-0 break-words text-sm font-semibold leading-5 sm:w-full sm:text-xs">
            <span class="sr-only">Step {step_number}: </span>
            {title}
            <span :if={step_number < @current_step_number} class="sr-only"> (completed)</span>
          </span>
        </li>
      </ol>
    </nav>
    """
  end

  attr :vacancies_empty?, :boolean, required: true
  attr :vacancies, Phoenix.LiveView.LiveStream, required: true

  @spec jobs(assigns()) :: rendered()
  def jobs(assigns) do
    ~H"""
    <section id="job-vacancies-list" class="w-full py-8">
      <h1 class="text-3xl font-bold tracking-tight text-slate-900">Job vacancies</h1>

      <div class="flex justify-end">
        <.link
          id="new-job-vacancy"
          patch={~p"/admin/jobs/new"}
          class="inline-flex mt-10 items-center justify-center gap-2 rounded-lg bg-slate-950 px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-slate-800 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-950"
        >
          <.icon name="hero-plus" class="size-5" /> New Job Vacancy
        </.link>
      </div>

      <div
        :if={@vacancies_empty?}
        id="job-vacancies-empty"
        class="mt-8 rounded-xl border border-dashed border-slate-300 px-6 py-12 text-center text-slate-500"
      >
        No job vacancies yet
      </div>

      <div id="job-vacancies" phx-update="stream" class="mt-8 grid gap-4 sm:grid-cols-2">
        <article
          :for={{id, vacancy} <- @vacancies}
          id={id}
          class="flex flex-col rounded-xl border border-slate-200 bg-white p-5 shadow-sm transition-shadow hover:shadow-md"
        >
          <div class="flex items-start justify-between gap-3">
            <h2 class="min-w-0 break-words text-lg font-semibold text-slate-900">
              {vacancy.job_title || "Untitled vacancy"}
            </h2>
            <span class={[
              "shrink-0 rounded-full px-2.5 py-1 text-xs font-medium",
              vacancy.status == :published && "bg-emerald-50 text-emerald-700",
              vacancy.status != :published && "bg-slate-100 text-slate-600"
            ]}>
              {vacancy_label(vacancy.status)}
            </span>
          </div>

          <p :if={vacancy.job_summary} class="mt-3 line-clamp-3 text-sm leading-6 text-slate-600">
            {vacancy.job_summary}
          </p>

          <dl class="mt-5 grid grid-cols-2 gap-4 border-t border-slate-100 pt-4 text-sm">
            <div>
              <dt class="text-xs text-slate-500">Location</dt>
              <dd class="mt-1 break-words text-slate-900">
                {vacancy.workplace_location || "Not specified"}
              </dd>
            </div>
            <div>
              <dt class="text-xs text-slate-500">Work arrangement</dt>
              <dd class="mt-1 text-slate-900">{vacancy_label(vacancy.work_arrangement)}</dd>
            </div>
            <div>
              <dt class="text-xs text-slate-500">Employment type</dt>
              <dd class="mt-1 text-slate-900">{vacancy_label(vacancy.employment_type)}</dd>
            </div>
            <div>
              <dt class="text-xs text-slate-500">Experience level</dt>
              <dd class="mt-1 text-slate-900">{vacancy_label(vacancy.experience_level)}</dd>
            </div>
            <div>
              <dt class="text-xs text-slate-500">Open positions</dt>
              <dd class="mt-1 text-slate-900">{vacancy.number_of_positions || "Not specified"}</dd>
            </div>
            <div>
              <dt class="text-xs text-slate-500">Application deadline</dt>
              <dd class="mt-1 text-slate-900">
                {if vacancy.application_deadline,
                  do: Calendar.strftime(vacancy.application_deadline, "%d %b %Y"),
                  else: "Not specified"}
              </dd>
            </div>
          </dl>

          <.link
            :if={vacancy.status == :draft}
            id={"edit-vacancy-#{vacancy.id}"}
            patch={edit_url(vacancy.id)}
            class="mt-5 inline-flex items-center gap-2 self-start text-sm font-semibold text-slate-900 transition-colors hover:text-slate-600"
          >
            Edit vacancy <.icon name="hero-arrow-right" class="size-4" />
          </.link>
        </article>
      </div>
    </section>
    """
  end

  attr :id, :string, required: true
  attr :previous_page_url, :string, required: true

  @spec back_button(assigns()) :: rendered()
  def back_button(assigns) do
    ~H"""
    <.link
      id={@id}
      patch={@previous_page_url}
      class="rounded-lg border border-slate-800 bg-slate-800 px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:border-slate-700 hover:bg-slate-700"
    >
      Back
    </.link>
    """
  end

  attr :id, :string, required: true

  @spec next_button(assigns()) :: rendered()
  def next_button(assigns) do
    ~H"""
    <button
      id={@id}
      type="submit"
      class="rounded-lg bg-slate-950 px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:cursor-pointer hover:bg-slate-800"
    >
      Next
    </button>
    """
  end

  defp vacancy_label(nil), do: "Not specified"

  defp vacancy_label(value) do
    value |> Atom.to_string() |> String.replace("_", " ") |> String.capitalize()
  end

  defp step_title("vacancy_details"), do: "Vacancy Details"
  defp step_title("job_description"), do: "Job Description"
  defp step_title("work_arrangement"), do: "Work Arrangement"
  defp step_title("compensation"), do: "Compensation"
  defp step_title("review_and_submit"), do: "Review and Submit"

  defp job_page_url, do: ~p"/admin/jobs/"

  defp edit_url(vacancy_id),
    do: job_page_url() <> "#{vacancy_id}/edit?page=vacancy_details"
end
