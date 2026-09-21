defmodule JobSiteWeb.Admin.JobsLive.FormComponent do
  use JobSiteWeb, :live_component

  alias JobSite.Vacancies.Vacancy
  alias JobSiteWeb.Admin.JobsLive.CompensationComponent
  alias JobSiteWeb.Admin.JobsLive.JobDescriptionComponent
  alias JobSiteWeb.Admin.JobsLive.JobVacancyComponents
  alias JobSiteWeb.Admin.JobsLive.ReviewSubmitComponent
  alias JobSiteWeb.Admin.JobsLive.VacancyDetailsComponent
  alias JobSiteWeb.Admin.JobsLive.WorkArrangementComponent
  alias JobSiteWeb.Step

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="w-[90%] mx-auto space-y-8 py-8">
      <JobVacancyComponents.stepper
        steps={@steps}
        current_step={@current_step}
      />

      <section :if={@current_step.name == "vacancy_details"}>
        <.live_component
          id="vacancy_details_component"
          action={@action}
          current_step={@current_step}
          vacancy={@vacancy}
          module={VacancyDetailsComponent}
        />
      </section>

      <section :if={@current_step.name == "job_description"}>
        <.live_component
          id="job_description_component"
          module={JobDescriptionComponent}
          current_step={@current_step}
          vacancy={@vacancy}
        />
      </section>

      <section :if={@current_step.name == "work_arrangement"}>
        <.live_component
          id="work_arrangement_component"
          module={WorkArrangementComponent}
          current_step={@current_step}
          vacancy={@vacancy}
        />
      </section>

      <section :if={@current_step.name == "compensation"}>
        <.live_component
          id="compensation_component"
          module={CompensationComponent}
          current_step={@current_step}
          vacancy={@vacancy}
        />
      </section>

      <section :if={@current_step.name == "review_and_submit"}>
        <.live_component
          id="review_and_submit_component"
          module={ReviewSubmitComponent}
          current_step={@current_step}
          vacancy={@vacancy}
        />
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    vacancy = assigns.vacancy || %Vacancy{}

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_step, find_step(assigns.step_name))
     |> assign(:steps, form_steps())
     |> assign(:vacancy, vacancy)}
  end

  defp form_steps do
    [
      %Step{name: "vacancy_details", prev: nil, next: "job_description"},
      %Step{name: "job_description", prev: "vacancy_details", next: "work_arrangement"},
      %Step{name: "work_arrangement", prev: "job_description", next: "compensation"},
      %Step{name: "compensation", prev: "work_arrangement", next: "review_and_submit"},
      %Step{name: "review_and_submit", prev: "compensation", next: nil}
    ]
  end

  defp find_step(name),
    do: Enum.find(form_steps(), &(&1.name == name))
end
