defmodule Seed.Server.Repository do
  use GenServer
  alias Seed.Server.Repository.Imp

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    IO.inspect(args)
    GenServer.start_link(Seed.Server.Repository, [], args)
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

  def handle_call({:update_by_id, module, id, payload}, _from, state) do
    response = Imp.update_by_id(module, id, payload)

    {:reply, response, state}
  end
end
