defmodule Seed.Server.Repository do
  use GenServer
  alias Seed.Server.Repository.Imp

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    GenServer.start_link(Seed.Server.Repository, [seed_id: args[:seed_id]], args)
  end

  def init(args) do
    {:ok, [seed_id: args[:seed_id]]}
  end

  def handle_call({:insert, module, payload}, _from, [seed_id: seed_id] = state) do
    response = Imp.insert(seed_id, {:insert, module, payload})

    {:reply, response, state}
  end

  def handle_call({:delete_by_id, id, soft_delete?}, _from, [seed_id: seed_id] = state) do
    response = Imp.delete(seed_id, {:delete_by_id, id, soft_delete?})

    {:reply, response, state}
  end

  def handle_call({:update_by_id, module, id, payload}, _from, [seed_id: seed_id] = state) do
    response = Imp.update_by_id(seed_id, module, id, payload)

    {:reply, response, state}
  end
end
