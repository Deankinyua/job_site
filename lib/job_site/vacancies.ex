defmodule JobSite.Vacancies do
  @moduledoc """
  The Vacancies context
  """

  # alias JobSite.Repo
  alias JobSite.Vacancies.Vacancy

  @type attrs :: map()
  @type changeset :: Ecto.Changeset.t()
  @type vacancy :: Vacancy.t()

  @spec change_vacancy_details(vacancy(), attrs()) :: changeset()
  def change_vacancy_details(application, attrs \\ %{}) do
    Vacancy.vacancy_details_changeset(application, attrs)
  end

  @spec change_job_description(vacancy(), attrs()) :: changeset()
  def change_job_description(application, attrs \\ %{}) do
    Vacancy.job_description_changeset(application, attrs)
  end

  @spec change_work_arrangement(vacancy(), attrs()) :: changeset()
  def change_work_arrangement(application, attrs \\ %{}) do
    Vacancy.work_arrangement_changeset(application, attrs)
  end

  @spec change_compensation(vacancy(), attrs()) :: changeset()
  def change_compensation(application, attrs \\ %{}) do
    Vacancy.compensation_changeset(application, attrs)
  end
end
