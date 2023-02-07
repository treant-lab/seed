defmodule Seed.Server.Entity.Client do
  def get_module(name) do
    GenServer.call(Seed.Util.entity(), {:get, name})
  end

  def push_schema(schema) do
    GenServer.cast(Seed.Util.entity(), {:push_schema, schema})
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
end
