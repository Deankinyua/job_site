defmodule JobSite.Vacancies.Vacancy do
  @moduledoc """
  A job vacancy
  """

  use JobSite.SchemaHelpers

  alias JobSite.Employers.Company

  @employment_types [
    :full_time,
    :part_time,
    :contract
  ]

  @experience_levels [
    :junior,
    :mid_level,
    :senior,
    :lead
  ]

  @work_arrangements [
    :onsite,
    :hybrid,
    :remote
  ]

  @statuses [
    :draft,
    :published
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "vacancies" do
    # Step 1: Vacancy details
    field :application_deadline, :date
    field :employment_type, Ecto.Enum, values: @employment_types
    field :experience_level, Ecto.Enum, values: @experience_levels
    field :job_title, :string
    field :number_of_positions, :integer, default: 1

    belongs_to :company, Company

    # Step 2: Job description
    field :job_summary, :string
    field :job_description, :string
    field :minimum_qualifications, {:array, :string}, default: []
    field :required_skills, {:array, :string}, default: []

    # Step 3: Work arrangements
    field :work_arrangement, Ecto.Enum, values: @work_arrangements
    field :working_hours, :string
    field :workplace_location, :string

    # Step 4: Compensation
    field :currency, :string, default: "USD"
    field :maximum_salary, :decimal
    field :minimum_salary, :decimal

    # ...other fields
    field :status, Ecto.Enum,
      values: @statuses,
      default: :draft

    timestamps(type: :utc_datetime)
  end
end
