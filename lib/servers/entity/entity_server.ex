defmodule Seed.Server.Entity do
  use GenServer
  alias Seed.Server.Entity.State
  alias Seed.Server.Entity.Imp

  def start_link([name: name, seed_id: id] = args) do
    GenServer.start_link(Seed.Server.Entity, [id: id], name: name)
  end

  def init(id: id) do
    {:ok, State.initial_state(id)}
  end

  def handle_call({:get, entity}, _from, state) do
    entity = Imp.get(entity, state.schemas)
    {:reply, entity, state}
  end

  def handle_call(:get_schemas, _from, %State{schemas: schemas} = state) do
    {:reply, {:ok, schemas}, state}
  end

  def handle_call(:count_schemas, _from, %State{schemas: schemas} = state) do
    {:reply, Enum.count(schemas), state}
  end

  def handle_cast({:push_schema, schema}, state) do
    state = State.push_schema(state, schema)
    {:noreply, state}
  end

  def handle_cast({:remove_schema, schema}, state) do
    state = State.remove_schema(state, schema)
    {:noreply, state}
  end

  def handle_call({:create, payload}, _from, state) do
    case Imp.create(payload, state) do
      {:ok, module, state} -> {:reply, {:ok, module}, state}
      error -> {:reply, error, state}
    end
  end

  def handle_call({:add_entity_field, entity_id, payload}, _from, %State{} = state) do
    case Imp.add_field(entity_id, payload, state) do
      {:ok, state, fields} -> {:reply, {:ok, fields}, state}
      error -> {:reply, error, state}
    end
  end

  def handle_call({:get_by_id, entity_id}, _from, state) do
    case State.get_schema_by_id(entity_id, state) do
      {:ok, schema, state} -> {:reply, {:ok, schema}, state}
      error -> {:reply, error, state}
    end
  end

  def handle_call({:remove_field_by_id, entity_id, field_id}, _from, state) do
    case Imp.remove_field(entity_id, field_id, state) do
      {:ok, field} -> {:reply, {:ok, field}, state}
      err -> {:reply, {:error, err}, state}
    end
  end

  def handle_call({:exists?, schema}, _from, state) do
    exists = Imp.exists?(schema, state.schemas)
    {:reply, exists, state}
  end
end
