defmodule Seed.Server.Entity do
  use GenServer
  alias Seed.Server.Entity.State
  alias Seed.Server.Entity.Imp

  def start_link(_args) do
    GenServer.start_link(Seed.Server.Entity, [], name: Seed.Util.entity())
  end

  def init(_args) do
    {:ok, State.initial_state()}
  end

  def handle_call({:get, entity}, _from, state) do
    entity = Imp.get(entity, state.schemas)
    {:reply, entity, state}
  end

  def handle_cast({:push_schema, schema}, state) do
    state = State.push_schema(state, schema)
    {:noreply, state}
  end
end
