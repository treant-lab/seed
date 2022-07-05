defmodule Seed.Server.Repository.Client do
  def insert(module, payload, from) do
    GenServer.call(Seed.Util.repository(), {:insert, module, payload, from})
  end

  def delete_by_id(id, soft_delete? \\ false) do
    GenServer.call(Seed.Util.repository(), {:delete_by_id, id, soft_delete?})
  end
end
