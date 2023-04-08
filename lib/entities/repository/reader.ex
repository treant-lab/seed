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

  def find(app_id, name) when is_binary(name) do
    match([
      {r, Root, %{uuid: app_id}},
      {entity, Entity},
      [{r}, [rel, IsEntity], {entity}]
    ])
    |> where(contains(entity.name, name))
    |> return([entity])
    |> Repo.all()
  end

  def by_id(app_id, uuid) do
    match([
      {r, Root, %{uuid: app_id}},
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

  def all(root_id) do
    match([
      {r, Root, %{uuid: root_id}},
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

  def get_entity_report(root_id) when is_binary(root_id) do
    Repo.query(
      """
        MATCH (r:Root {uuid: $root_id})
        MATCH (r)-[:IS_ENTITY]->(e:Entity)
        MATCH (data)-[:IS_DATA]->(r)

        RETURN
          COUNT(DISTINCT e) AS amountEntities,
          COUNT(DISTINCT data) AS amountData
      """,
      %{root_id: root_id}
    )
    |> case do
      {:ok, data} -> {:ok, data}
      _ -> {:error}
    end
  end
end
