# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     JobSite.Repo.insert!(%JobSite.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias JobSite.Employers

[
  %{name: "Amazon", headquarters: "Seattle", company_size: "10-50"},
  %{name: "Google", headquarters: "San Fransisco", company_size: "400-500"},
  %{name: "Microsoft", headquarters: "Washington DC", company_size: "200-300"}
]
|> Stream.reject(&Employers.get_company_by_name(&1.name))
|> Enum.each(&Employers.create_company/1)
