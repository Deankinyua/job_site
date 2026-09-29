defmodule JobSiteWeb.Admin.JobsLive.Helpers do
  @moduledoc """
  Helpers used in the Job Vacancy creation process.
  """

  alias JobSite.Vacancies.Vacancy
  alias JobSiteWeb.Step

  @type step :: Step.t()
  @type vacancy :: Vacancy.t()

  @spec next_step(vacancy(), step()) :: {:next_step, vacancy(), step()}
  def next_step(vacancy, step), do: send(self(), {:next_step, vacancy, step})
end
