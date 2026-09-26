defmodule JobSite.Vacancies do
  @moduledoc """
  The Vacancies context
  """

  import Ecto.Query, only: [order_by: 3, where: 3]

  alias JobSite.Repo
  alias JobSite.Vacancies.Vacancy

  @type attrs :: map()
  @type changeset :: Ecto.Changeset.t()
  @type vacancy :: Vacancy.t()

  @spec change_vacancy_details(vacancy(), attrs()) :: changeset()
  def change_vacancy_details(vacancy, attrs \\ %{}) do
    Vacancy.vacancy_details_changeset(vacancy, attrs)
  end

  @spec change_job_description(vacancy(), attrs()) :: changeset()
  def change_job_description(vacancy, attrs \\ %{}) do
    Vacancy.job_description_changeset(vacancy, attrs)
  end

  @spec change_work_arrangement(vacancy(), attrs()) :: changeset()
  def change_work_arrangement(vacancy, attrs \\ %{}) do
    Vacancy.work_arrangement_changeset(vacancy, attrs)
  end

  @spec change_compensation(vacancy(), attrs()) :: changeset()
  def change_compensation(vacancy, attrs \\ %{}) do
    Vacancy.compensation_changeset(vacancy, attrs)
  end

  @doc """
  Gets a job vacancy.
  """
  @spec get_job_vacancy(String.t()) :: vacancy() | nil
  def get_job_vacancy(id), do: Repo.get_by(Vacancy, id: id)

  @doc """
  Lists job vacancies on the admin side of the site.
  """
  @spec list_vacancies_for_admin :: [vacancy()]
  def list_vacancies_for_admin do
    Vacancy
    |> order_by([vacancy], desc: vacancy.inserted_at)
    |> Repo.all()
  end

  @doc """
  Lists job vacancies for the public-facing side of the site.
  """
  @spec list_published_vacancies :: [vacancy()]
  def list_published_vacancies do
    Vacancy
    |> where([vacancy], vacancy.status == :published)
    |> order_by([vacancy], desc: vacancy.inserted_at)
    |> Repo.all()
  end

  @doc """
  Saves a job vacancy as it moves through each step/page.
  """
  @spec save_job_vacancy(changeset()) :: {:ok, vacancy()} | {:error, changeset()}
  def save_job_vacancy(changeset), do: Repo.insert_or_update(changeset)

  @doc """
  Publishes a job vacancy. Checks if all fields are present.
  """
  @spec publish_job_vacancy(vacancy(), attrs()) :: {:ok, vacancy()} | {:error, changeset()}
  def publish_job_vacancy(vacancy, attrs \\ %{}) do
    vacancy
    |> Vacancy.submit_changeset(attrs)
    |> Repo.update()
  end
end
