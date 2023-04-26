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

    %__MODULE__{state | schemas: Imp.get_all_schemas(root_id)}
  end

  def push_schema(state, schema) do
    %__MODULE__{state | schemas: [schema | state.schemas]}
  end

  def remove_schema(%__MODULE__{schemas: schemas} = state, schema) do
    schemas =
      Enum.filter(schemas, fn {module, _} ->
        module.name() != schema
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
      {module, _} -> {:ok, module.schema(), state}
    end
  end

  def schema_to_map(%__MODULE__{schemas: schemas} = _state) do
    Enum.map(schemas, fn {module, _} ->
      module.schema()
    end)
  end
end
