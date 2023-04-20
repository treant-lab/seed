defmodule Seed.Entities.Repository.Remover do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  alias Seed.Entities.Schema.Relationships.NoProps.RootToEntity.IsEntity
  alias Seed.Roots.Schema.Root
  import Seraph.Query

  def by_id(app_id, uuid, soft_delete? \\ false) when is_binary(uuid) do
    match([
      {r, Root, %{uuid: app_id}},
      {entity, Entity, %{uuid: uuid}},
      [{r}, [rel, IsEntity], {entity}]
    ])
    |> return([entity])
    |> Repo.one()
    |> case do
      nil ->
        {:error, :invalid_id}

      %{"entity" => entity} ->
        delete_entity(app_id, entity, soft_delete?)
    end
  end

  defp delete_entity(app_id, entity, true = _soft_delete?) do
    Repo.query(
      """
      MATCH (root:Root {uuid: $app_id})-[is_data:IS_ENTITY]-(n {uuid: $entity_id})
      CREATE (root)-[deleted_data:DELETED_DATA]->(n)
      SET deleted_data = is_data
      WITH is_data
      DELETE is_data
      """,
      %{
        app_id: app_id,
        entity_id: entity.uuid
      }
    )
  end

  defp delete_entity(_app_id, entity, false = _soft_delete?) do
    Repo.Node.delete(entity)
  end
end
