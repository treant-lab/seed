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
    Repo.query("""
    MATCH (e {uuid: $entity_id})
    MATCH (root:Root {uuid: $app_id})
    CREATE (e)-[rel:IS_DATA {createdAt: datetime()}]->(root)
    RETURN e, rel, root
    """, %{entity_id: entity.uuid, app_id: App.id()})
    |> case do
      {:ok, _data} ->
      {:ok, entity}
      err -> err
    end
  end
end
