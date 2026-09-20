defmodule JobSiteWeb.Step do
  @moduledoc """
  A step struct. Stores the names of the current,
  previous and next steps.
  """

  @type t :: %__MODULE__{}

  defstruct [:name, :prev, :next]
end
