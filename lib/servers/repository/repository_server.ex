defmodule Seed.Server.Repository do
  use GenServer
  alias Seed.Server.Repository.Imp

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_args) do
    GenServer.start_link(Seed.Server.Repository, [], name: Seed.Util.repository())
  end

  def init(_args) do
    {:ok, []}
  end

  def handle_call({:insert, module, payload, from}, _from, state) do
    response = Imp.insert({:insert, module, payload, from})

    {:reply, response, state}
  end

  def handle_call({:delete_by_id, id, soft_delete?}, _from, state) do
    response = Imp.delete({:delete_by_id, id, soft_delete?})

    {:reply, response, state}
  end
end
