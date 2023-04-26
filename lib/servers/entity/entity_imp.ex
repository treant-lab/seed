defmodule Seed.Server.Entity.Imp do
  alias Seed.Entities.Repository.Reader
  alias Seed.Entities.Services.EntityBuilder
  alias Seed.Server.Entity.State

  def get_all_schemas(root_id) do
    schemas =
      Reader.all(root_id)
      |> Parallel.pmap(&EntityBuilder.call!/1)

    schemas
  end

  def get(name, schemas) do
    Enum.find(schemas, fn {schema, _} ->
      schema.name() == name
    end)
  end

  def get_by_id(id, schemas) do
    Enum.find(schemas, fn {module, _} ->
      module.id() == id
    end)
  end

  def exists?(name, schemas) do
    Enum.find(schemas, fn {schema, _} ->
      schema.name() == name
    end)
    |> case do
      nil -> false
      _ -> true
    end
  end

  def add_field(entity_id, payload, %State{id: id} = state) do
    with {:ok, entity} <-
           Seed.Entities.Repository.Reader.by_id(id, entity_id),
         {:ok, fields} <-
           Seed.Entities.Repository.Aggregates.Field.create_fields(entity, [payload]),
         {:ok, entity} <-
           Seed.Entities.Repository.Reader.by_id(id, entity_id),
         {:ok, schema} <- Seed.Entities.Services.EntityBuilder.call(entity),
         state <- Seed.Server.Entity.State.replace_schema(state, schema) do
      {:ok, state, fields}
    else
      error ->
        error
    end
  end

  def update_entity_color(entity_id, color, %State{id: id} = state) do
    with {:ok, entity} <-
           Seed.Entities.Repository.Reader.by_id(id, entity_id),
         {:ok, _} <-
           Seed.Entities.Repository.Updater.update_color(id, entity_id, color),
         {:ok, entity} <-
           Seed.Entities.Repository.Reader.by_id(id, entity_id),
         {:ok, schema} <- Seed.Entities.Services.EntityBuilder.call(entity),
         state <- Seed.Server.Entity.State.replace_schema(state, schema) do
      {:ok, state, entity}
    else
      error ->
        error
    end
  end

  def remove_field(entity_id, field_id, %State{id: id} = _state) do
    Seed.Entities.Repository.Aggregates.Field.remove_field(id, entity_id, field_id)
  end

  def create(payload, %State{id: id} = state) do
    with {:ok, entity} <- Seed.Entities.Services.Creation.call(payload, id),
         {:ok, module} <- Seed.Entities.Services.EntityBuilder.call(entity),
         %State{} = state <- State.push_schema(state, module) do
      {:ok, module, state}
    else
      error -> error
    end
  end
end
