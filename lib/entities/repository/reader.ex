defmodule Seed.Entities.Repository.Reader do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  alias Seed.Entities.Schema.Relationships.NoProps.RootToEntity.IsEntity
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

  @spec find(binary) :: [map] | %{results: [map], stats: map}
  def find(name) when is_binary(name) do
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

  def all() do
    match([
      {r, Root, %{uuid: Seed.Settings.App.id()}},
      {entity, Entity},
      [{r}, [rel, IsEntity], {entity}]
    ])
    |> return([entity])
    |> Repo.all()
    |> extract_entity()
  end

  defp extract_entity(entities) when is_list(entities) do
    entities
    |> Enum.map(fn %{"entity" => entity} -> entity end)
  end
end
