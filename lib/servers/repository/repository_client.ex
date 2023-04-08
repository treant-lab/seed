defmodule Seed.Server.Repository.Client do
  def insert(app_id, module, payload) do
    GenServer.call(server(app_id), {:insert, module, payload})
  end

  def delete_by_id(app_id, id, soft_delete? \\ false) do
    GenServer.call(server(app_id), {:delete_by_id, id, soft_delete?})
  end

  def update_by_id(app_id, module, id, payload) do
    GenServer.call(server(app_id), {:update_by_id, module, id, payload})
  end

  defp server(id) when is_binary(id) do
    :"Repository-#{id}"
  end

  defp server(id) when is_atom(id) do
    id
  end
end
