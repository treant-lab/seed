defmodule Seed.Entities.Repository.Reader do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.{Entity, Relationships.Field}
  alias Seed.Entities.Schema.Relationships.NoProps.{EntityToField.IsField, RootToEntity.IsEntity}
  alias Seed.Roots.Schema.Root
  import Seraph.Query

  def exists?(name) do
    query =
      match(
        [
          {e, Entity, %{name: name}}
        ],
        return: [e]
      )

    Repo.one(query)
    |> case do
      nil -> false
      _ -> true
    end
  end

  def find(name) when is_binary(name) do
    query =
      match([
        {r, Root, %{uuid: Seed.Settings.App.id()}},
        {entity, Entity},
        [{r}, [rel, IsEntity], {entity}]
      ])
      |> where(contains(entity.name, name))
      |> return([entity])
      |> Repo.all()
  end

  def by_id(uuid) do
    match([
      {r, Root, %{uuid: Seed.Settings.App.id()}},
      {entity, Entity, %{uuid: uuid}},
      [{r}, [rel, IsEntity], {entity}]
    ])
    |> return([entity])
    |> Repo.one()
    |> case do
      %{"entity" => entity} ->
        {:ok, entity}

      nil ->
        {:error, :invalid_id}
    end
  end

  def preload_fields(entity) do
  end
end
