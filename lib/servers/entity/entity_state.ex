defmodule Seed.Server.Entity.State do
  defstruct schemas: [], id: ""
  alias Seed.Server.Entity.Imp

  @type t :: %{
          schemas: list(Seraph.Schema.t()),
          id: binary()
        }

  def initial_state(root_id) do
    state = %__MODULE__{
      id: root_id
    }

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

  def replace_schema(%__MODULE__{schemas: schemas} = state, {module, _} = schema) do
    schemas =
      Enum.map(schemas, fn {module_stored, _} = args ->
        case module_stored.id() == module.id() do
          true -> schema
          false -> args
        end
      end)

    %__MODULE__{state | schemas: schemas}
  end

  def get_schema_by_id(id, %__MODULE__{schemas: schemas} = state) do
    Enum.find(schemas, fn {module, _} -> module.id() == id end)
    |> case do
      nil -> {:error, "entity not found."}
      schema -> {:ok, schema, state}
    end
  end
end
