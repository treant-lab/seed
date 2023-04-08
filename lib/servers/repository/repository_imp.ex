defmodule Seed.Server.Repository.Imp do
  alias Seed.Server.Entity
  alias Seed.Database.Repo
  import Seraph.Query

  def insert(app_id, {:insert, module, payload} = _params) do
    {module, _} = Entity.Client.get_module(app_id, module)
    changeset = module.changeset(payload)

    Repo.Node.create(changeset)
    |> case do
      {:ok, entity} -> create_relation_with_root(app_id, entity)
      err -> {:error, err}
    end
  end

  defp create_relation_with_root(app_id, entity) do
    Repo.query(
      """
      MATCH (e {uuid: $entity_id})
      MATCH (root:Root {uuid: $app_id})
      CREATE (e)-[rel:IS_DATA {createdAt: datetime()}]->(root)
      RETURN e, rel, root
      """,
      %{entity_id: entity.uuid, app_id: app_id}
    )
    |> case do
      {:ok, _data} ->
        {:ok, entity}

      err ->
        err
    end
  end

  def delete(app_id, {:delete_by_id, id, false = _soft_delete?}) do
    Repo.query(
      """
        MATCH (root:Root {uuid: $app_id})-[is_data:IS_DATA]-(n {uuid: $entity_id})
        DETACH DELETE n
      """,
      %{
        app_id: app_id,
        entity_id: id
      }
    )
    |> case do
      {:ok, []} -> :ok
      err -> err
    end
  end

  def delete(seed_id, {:delete_by_id, id, true = _soft_delete?}) do
    Repo.query(
      """
        MATCH (root:Root {uuid: $app_id})-[is_data:IS_DATA]-(n {uuid: $entity_id})
        CREATE (n)-[deleted_data:DELETED_DATA]->(root)
        SET deleted_data = is_data
        WITH is_data, n
        DELETE is_data
        RETURN n
      """,
      %{
        app_id: seed_id,
        entity_id: id
      }
    )
    |> case do
      {:ok, [%{"n" => %Bolt.Sips.Types.Node{labels: [label_name]}}]} ->
        entity = find_entity_by_id(seed_id, label_name, id)
        {:ok, entity}

      err ->
        err
    end
  end

  def find_entity_by_id(app_id, entity_name, id) do
    {entity_module, _} = Seed.Server.Entity.Client.get_module(app_id, entity_name)
    Repo.Node.get(entity_module, id)
  end

  def update_by_id(app_id, entity_name, id, payload) do
    {entity_module, _} = Seed.Server.Entity.Client.get_module(app_id, entity_name)
    entity = find_entity_by_id(app_id, entity_name, id)

    entity_module.changeset_update(entity, payload)
    |> Repo.Node.set()
  end
end
