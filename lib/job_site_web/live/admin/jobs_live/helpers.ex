defmodule JobSiteWeb.Admin.JobsLive.Helpers do
  @moduledoc """
  Helpers used in the Job Vacancy creation process.
  """

  import Phoenix.Component, only: [to_form: 2, assign: 3]

  alias JobSite.Vacancies
  alias JobSite.Vacancies.Vacancy
  alias JobSiteWeb.Step

  @type changeset :: Ecto.Changeset.t()
  @type socket :: Phoenix.LiveView.Socket.t()
  @type step :: Step.t()
  @type vacancy :: Vacancy.t()

  @doc """
  Advances to the next step by sending a message to the LiveView
  with the updated struct and current step.
  """
  @spec next_step(vacancy(), step()) :: {:next_step, vacancy(), step()}
  def next_step(vacancy, step), do: send(self(), {:next_step, vacancy, step})

  @doc """
  On successful saving of the job vacancy, advances to the next step;
  otherwise remains on the same step optionally rendering validation errors.
  """
  @spec maybe_advance_to_next_page(changeset(), socket()) :: {:noreply, socket()}
  def maybe_advance_to_next_page(
        %Ecto.Changeset{valid?: true} = changeset,
        %{assigns: %{current_step: step}} = socket
      ) do
    case Vacancies.save_job_vacancy(changeset) do
      {:ok, vacancy} ->
        next_step(vacancy, step)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(%{changeset | action: :validate}, []))}
    end
  end

  def maybe_advance_to_next_page(changeset, socket) do
    {:noreply, assign(socket, :form, to_form(%{changeset | action: :validate}, []))}
  end
end
