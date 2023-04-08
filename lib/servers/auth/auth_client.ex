defmodule Seed.Server.Auth.Client do
  def get_module(id, name) do
    GenServer.call(:"Auth-#{id}", {:get, name})
  end

  def push_schema(id, schema) do
    GenServer.cast(:"Auth-#{id}", {:push_schema, schema})
  end

  def remove_schema(id, schema) when is_atom(schema) do
    GenServer.cast(:"Auth-#{id}", {:remove_schema, schema})
  end

  def get_schemas(id) do
    GenServer.call(:"Auth-#{id}", :get_schemas)
  end

  def exists?(id, schema) do
    GenServer.call(:"Auth-#{id}", {:exists?, schema})
  end
end
