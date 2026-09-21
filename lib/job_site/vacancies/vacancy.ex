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

  @vacancy_fields [
    :application_deadline,
    :employment_type,
    :experience_level,
    :job_title,
    :number_of_positions,
    :company_id,
    :job_summary,
    :job_description,
    :minimum_qualifications,
    :required_skills,
    :work_arrangement,
    :working_hours,
    :workplace_location,
    :currency,
    :maximum_salary,
    :minimum_salary
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

    # Step 3: Work arrangement
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

  # We never cast the :status
  @spec changeset(t(), map()) :: changeset()
  def changeset(vacancy, attrs) do
    cast(vacancy, attrs, @vacancy_fields)
  end

  @spec vacancy_details_changeset(t(), map()) :: changeset()
  def vacancy_details_changeset(vacancy, attrs) do
    vacancy
    |> changeset(attrs)
    |> validate_required([
      :application_deadline,
      :company_id,
      :employment_type,
      :experience_level,
      :job_title,
      :number_of_positions
    ])
  end

  @spec job_description_changeset(t(), map()) :: changeset()
  def job_description_changeset(vacancy, attrs) do
    vacancy
    |> changeset(attrs)
    |> validate_required([
      :job_description,
      :job_summary,
      :minimum_qualifications,
      :required_skills
    ])
  end

  @spec work_arrangement_changeset(t(), map()) :: changeset()
  def work_arrangement_changeset(vacancy, attrs) do
    vacancy
    |> changeset(attrs)
    |> validate_required([:work_arrangement, :working_hours, :workplace_location])
  end

  @spec compensation_changeset(t(), map()) :: changeset()
  def compensation_changeset(vacancy, attrs) do
    vacancy
    |> changeset(attrs)
    |> validate_required([:currency, :maximum_salary, :minimum_salary])
  end

  @spec submit_changeset(t(), map()) :: changeset()
  def submit_changeset(application, attrs) do
    application
    |> changeset(attrs)
    |> validate_required(@vacancy_fields)
    |> maybe_submit_application()
  end

  defp maybe_submit_application(changeset) when changeset.valid? == true,
    do: put_change(changeset, :status, :published)

  defp maybe_submit_application(changeset),
    do: changeset
end
