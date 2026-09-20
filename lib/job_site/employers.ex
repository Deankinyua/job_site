defmodule JobSite.Employers do
  @moduledoc """
  The Employers context.
  """

  alias JobSite.Employers.Company
  alias JobSite.Repo

  @type attrs :: map()
  @type changeset :: Ecto.Changeset.t()
  @type company :: Company.t()
  @type company_name :: String.t()

  @doc """
  Creates a company.
  """
  @spec create_company(attrs()) :: {:ok, company()} | {:error, changeset()}
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_company_by_name(company_name()) :: company() | nil
  def get_company_by_name(name), do: Repo.get_by(Company, name: name)
end
