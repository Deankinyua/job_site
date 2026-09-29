defmodule JobSiteWeb.Admin.JobsLive.VacancyDetailsComponent do
  use JobSiteWeb, :live_component

  use JobSiteWeb.VacancyFormHelpers

  alias JobSite.Employers

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="rounded-2xl border border-slate-700 bg-slate-900 p-5 shadow-lg shadow-slate-950/20 sm:p-8">
      <h1 class="text-xl font-semibold text-slate-100">Vacancy Details</h1>

      <.form
        for={@form}
        id="vacancy-details-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="mt-6 space-y-5 [&_.label]:text-slate-200"
      >
        <.input
          field={@form[:job_title]}
          type="text"
          label="Job title *"
          class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
        />
        <.input
          field={@form[:company_id]}
          type="select"
          options={@company_options}
          label="Company Name *"
          class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
        />

        <div class="grid gap-5 sm:grid-cols-2">
          <.input
            field={@form[:employment_type]}
            type="select"
            label="Employment type *"
            prompt="Select employment type"
            options={@employment_type_options}
            class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
          />
          <.input
            field={@form[:experience_level]}
            type="select"
            label="Experience level *"
            prompt="Select experience level"
            options={@experience_level_options}
            class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
          />
          <.input
            field={@form[:number_of_positions]}
            type="number"
            label="Number of positions *"
            min="1"
            class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
          />
          <.input
            field={@form[:application_deadline]}
            type="date"
            label="Application deadline *"
            class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
          />
        </div>

        <div class="flex justify-end border-t border-slate-700 pt-5">
          <JobVacancyComponents.next_button id="vacancy-details-next" />
        </div>
      </.form>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    companies = Enum.map(Employers.list_companies(), &{&1.name, &1.id})

    new_assigns = %{
      company_options: companies,
      employment_type_options: [
        {"Full-Time", :full_time},
        {"Part-Time", :part_time},
        {"Contract", :contract}
      ],
      experience_level_options: [
        {"Junior", :junior},
        {"Mid level", :mid_level},
        {"Senior", :senior},
        {"Lead", :lead}
      ]
    }

    {:ok,
     socket
     |> assign(assigns)
     |> assign(new_assigns)
     |> assign_new(:form, fn -> to_form(Vacancies.change_vacancy_details(assigns.vacancy)) end)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"vacancy" => params}, socket) do
    form =
      socket.assigns.vacancy
      |> Vacancies.change_vacancy_details(params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"vacancy" => params}, socket) do
    changeset = Vacancies.change_vacancy_details(socket.assigns.vacancy, params)
    maybe_advance_to_next_page(changeset, socket)
  end

  defp maybe_advance_to_next_page(
         %Ecto.Changeset{valid?: true} = changeset,
         %{assigns: %{action: action, current_step: step}} = socket
       ) do
    case Vacancies.save_job_vacancy(changeset) do
      {:ok, vacancy} ->
        if action == :new,
          do: send(self(), {:second_step, vacancy, step}),
          else: Helpers.next_step(vacancy, step)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(%{changeset | action: :validate}))}
    end
  end

  defp maybe_advance_to_next_page(changeset, socket) do
    {:noreply, assign(socket, :form, to_form(%{changeset | action: :validate}))}
  end
end
