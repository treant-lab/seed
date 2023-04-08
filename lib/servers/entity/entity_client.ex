defmodule Seed.Server.Entity.Client do
  def create(id, payload) do
    GenServer.call(server(id), {:create, payload})
  end

  def add_field(id, entity_id, payload) do
    GenServer.call(server(id), {:add_entity_field, entity_id, payload})
  end

  defp server(id) when is_binary(id) do
    :"Entity-#{id}"
  end

  defp server(id) when is_atom(id) do
    id
  end

  def get_module(name) do
    GenServer.call(Seed.Util.entity(), {:get, name})
  end

  def push_schema(id, schema) do
    GenServer.cast(server(id), {:push_schema, schema})
  end

  def count(id) do
    GenServer.call(server(id), :count_schemas)
  end

  def remove_schema(schema) when is_atom(schema) do
    GenServer.cast(Seed.Util.entity(), {:remove_schema, schema})
  end

  def get_schemas() do
    GenServer.call(Seed.Util.entity(), :get_schemas)
  end

  def exists?(schema) do
    GenServer.call(Seed.Util.entity(), {:exists?, schema})
  end

  def get_by_id(id, entity_id) do
    GenServer.call(server(id), {:get_by_id, entity_id})
  end

  def remove_field_by_id(id, entity_id, field_id) do
    GenServer.call(server(id), {:remove_field_by_id, entity_id, field_id})
  end
end
