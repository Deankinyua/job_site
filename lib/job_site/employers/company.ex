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
  end
end
