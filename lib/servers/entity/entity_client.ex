defmodule Seed.Server.Entity.Client do
  def get_module(name) do
    GenServer.call(Seed.Util.entity(), {:get, name})
  end

  def push_schema(schema) do
    GenServer.cast(Seed.Util.entity(), {:push_schema, schema})
  end
end
