defmodule JobSiteWeb.Admin.JobsLive.CompensationComponent do
  use JobSiteWeb, :live_component

  use JobSiteWeb.VacancyFormHelpers

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="rounded-2xl border border-slate-700 bg-slate-900 p-5 shadow-lg shadow-slate-950/20 sm:p-8">
      <h1 class="text-xl font-semibold text-slate-100">Compensation Terms</h1>

      <.form
        for={@form}
        id="compensation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="mt-6 space-y-5 [&_.label]:text-slate-200"
      >
        <.input
          field={@form[:currency]}
          type="text"
          label="Currency (optional)"
          placeholder="USD"
          class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 placeholder:text-slate-400 focus:border-slate-400 focus:outline-none"
        />

        <div class="grid gap-5 sm:grid-cols-2">
          <.input
            field={@form[:minimum_salary]}
            type="number"
            label="Minimum Salary *"
            min="0"
            class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
          />

          <.input
            field={@form[:maximum_salary]}
            type="number"
            label="Maximum Salary *"
            min="0"
            class="w-full rounded-lg border border-slate-600 bg-slate-800 px-3 py-2.5 text-slate-100 focus:border-slate-400 focus:outline-none"
          />
        </div>

        <div class="flex justify-between border-t border-slate-700 pt-5">
          <JobVacancyComponents.back_button
            id="compensation-back"
            previous_page_url={~p"/admin/jobs/#{@vacancy.id}/edit/?page=work_arrangement"}
          />

          <JobVacancyComponents.next_button id="compensation-next" />
        </div>
      </.form>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn -> to_form(Vacancies.change_compensation(assigns.vacancy)) end)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"vacancy" => params}, socket) do
    form =
      socket.assigns.vacancy
      |> Vacancies.change_compensation(params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"vacancy" => params}, socket) do
    changeset = Vacancies.change_compensation(socket.assigns.vacancy, params)
    Helpers.maybe_advance_to_next_page(changeset, socket)
  end
end
