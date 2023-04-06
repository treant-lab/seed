defmodule Seed.Server.Entity do
  use GenServer
  alias Seed.Server.Entity.State
  alias Seed.Server.Entity.Imp

  def start_link(args) do
    IO.inspect(args)
    GenServer.start_link(Seed.Server.Entity, [], args)
  end

  def init(_args) do
    {:ok, State.initial_state()}
  end

  def handle_call({:get, entity}, _from, state) do
    entity = Imp.get(entity, state.schemas)
    {:reply, entity, state}
  end

  def handle_call(:get_schemas, _from, %State{schemas: schemas} = state) do
    {:reply, schemas, state}
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

  def handle_call({:exists?, schema}, _from, state) do
    exists = Imp.exists?(schema, state.schemas)
    {:reply, exists, state}
  end
end
