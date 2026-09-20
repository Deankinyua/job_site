defmodule JobSite.Repo.Migrations.CreateJobVacancies do
  use Ecto.Migration

  def change do
    create table(:vacancies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :application_deadline, :date
      add :currency, :string
      add :employment_type, :string
      add :experience_level, :string
      add :job_description, :text
      add :job_summary, :text
      add :job_title, :string
      add :maximum_salary, :decimal
      add :minimum_qualifications, {:array, :text}
      add :minimum_salary, :decimal
      add :number_of_positions, :integer
      add :required_skills, {:array, :string}
      add :status, :string
      add :work_arrangement, :string
      add :working_hours, :string
      add :workplace_location, :string

      add :company_id, references(:companies, type: :binary_id, on_delete: :delete_all),
        null: false

      timestamps(type: :timestamptz)
    end
  end
end
