defmodule JobSite do
  @moduledoc """
  JobSite keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmodule SchemaHelpers do
    @moduledoc """
    Defines common configuration for all schemas
    """

    @type changeset :: Ecto.Changeset.t()

    defmacro __using__(_opts) do
      quote do
        use Ecto.Schema

        import Ecto.Changeset

        @type attrs :: map()
        @type changeset :: Ecto.Changeset.t()
        @type t :: %__MODULE__{}
      end
    end
  end
end
