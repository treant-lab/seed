defmodule Seed.Server.Entity.State do
  defstruct schemas: []
  alias Seed.Server.Entity.Imp

  @type t :: %{
          schemas: list(Seraph.Schema.t())
        }

  @spec initial_state :: %__MODULE__{}
  def initial_state do
    state = %__MODULE__{}

    %__MODULE__{state | schemas: Imp.get_all_schemas()}
  end
end
