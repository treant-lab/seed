defmodule Seed.Server.Entity.State do
  defstruct schemas: []
  alias Seed.Server.Entity.Imp

  @type t :: %{
          schemas: list(Seraph.Schema.t())
        }

  def initial_state do
    state = %__MODULE__{}

    %__MODULE__{state | schemas: Imp.get_all_schemas()}
  end

  def push_schema(state, schema) do
    %__MODULE__{state | schemas: [schema | state.schemas]}
  end

  def remove_schema(%__MODULE__{schemas: schemas} = state, schema) do
    schemas =
      Enum.filter(schemas, fn {schema_name, _} ->
        schema_name != schema
      end)

    %__MODULE__{state | schemas: schemas}
  end
end
