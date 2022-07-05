defmodule Seed.Server.Repository.Imp do
  alias Seed.Server.Entity
  alias Seed.Database.Repo
  alias Seed.Settings.App
  import Seraph.Query

  def insert({:insert, module, payload, _from} = _params) do
    module = Entity.Client.get_module(module)
    changeset = module.changeset(payload)

    Repo.Node.create(changeset)
    |> case do
      {:ok, entity} -> create_relation_with_root(entity)
      err -> {:error, err}
    end
  end

  defp create_relation_with_root(entity) do
    Repo.query(
      """
      MATCH (e {uuid: $entity_id})
      MATCH (root:Root {uuid: $app_id})
      CREATE (e)-[rel:IS_DATA {createdAt: datetime()}]->(root)
      RETURN e, rel, root
      """,
      %{entity_id: entity.uuid, app_id: App.id()}
    )
    |> case do
      {:ok, _data} ->
        {:ok, entity}

      err ->
        err
    end
  end

  def delete({:delete_by_id, id, false = _soft_delete?}) do
    Repo.query(
      """
        MATCH (root:Root {uuid: $app_id})-[is_data:IS_DATA]-(n {uuid: $entity_id})
        DETACH DELETE n
      """,
      %{
        app_id: Seed.Settings.App.id(),
        entity_id: id
      }
    )
    |> case do
      {:ok, []} -> :ok
      err -> err
    end
  end

  def delete({:delete_by_id, id, true = _soft_delete?}) do
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
        app_id: Seed.Settings.App.id(),
        entity_id: id
      }
    )
    |> case do
      {:ok, [%{"n" => %Bolt.Sips.Types.Node{labels: [label_name]}}]} ->
        entity = find_entity_by_id(label_name, id)
        {:ok, entity}

      err ->
        err
    end
  end

  def find_entity_by_id(entity_name, id) do
    entity_module = Seed.Server.Entity.Client.get_module(entity_name)
    Repo.Node.get(entity_module, id)
  end
end
