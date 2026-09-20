defmodule JobSite.Repo do
  use Ecto.Repo,
    otp_app: :job_site,
    adapter: Ecto.Adapters.Postgres
end
