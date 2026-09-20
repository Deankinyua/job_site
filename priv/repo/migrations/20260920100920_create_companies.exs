defmodule JobSite.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :company_size, :string, null: false
      add :headquarters, :string, null: false
      add :name, :string, null: false

      timestamps(type: :timestamptz)
    end
  end
end
