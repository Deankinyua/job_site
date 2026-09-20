defmodule JobSite.Employers.Company do
  @moduledoc """
  A company/organization offering employment opportunities.
  """

  use JobSite.SchemaHelpers

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :company_size, :string
    field :headquarters, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @spec changeset(t(), map()) :: changeset()
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:company_size, :headquarters, :name])
    |> validate_required([:company_size, :headquarters, :name])
  end
end
