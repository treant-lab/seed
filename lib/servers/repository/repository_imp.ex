defmodule Seed.Server.Repository.Imp do
  alias Seed.Server.Entity
  alias Seed.Database.Repo

  alias Seed.Settings.App
  alias Seed.Roots.Schema.Root
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

  def update_by_id(entity_name, id, payload) do
    entity_module = Seed.Server.Entity.Client.get_module(entity_name)
    entity = find_entity_by_id(entity_name, id)

    entity_module.changeset_update(entity, payload)
    |> Repo.Node.set()
  end

  def find_by(entity_name, payload) do
    entityModule = Seed.Server.Entity.Client.get_module(entity_name)

    # Macro.expand(entityModule)
    # |> IO.inspect()

    query =
      match([
        {e, Root, %{uuid: "hdusahudashudas"}}
      ])
      |> IO.inspect()

    # IO.inspect(entityModule.changeset(%{}))
    # EntityModule.__info__(:attributes)
    # |> IO.inspect()
    # c = Root
    # IO.inspect(Seed.Settings.App.id())

    # Repo.query(
    #   """
    #   MATCH (root:Root {uuid: $app_id})-[is_data:IS_DATA]-(data)
    #   WITH data
    #   MATCH (n:Example94e9096e4c {username: "Hello-2764b882b1"})
    #   RETURN n
    #   """,
    #   %{app_id: Seed.Settings.App.id()}
    # )

    # |> Repo.all()

    # Code.eval_quoted(
    #   quote do
    #     alias entity_module
    #     __ENV__
    #   end
    # )

    # alias entity_module, as: Enity
    # Module.ali
    # IO.inspect(entity_module)
    # a = Root
    # is_data = Module.concat([entity_module, IsData])
    # query = 10
    # a =
    #   match([
    #     {root, Root, %{uuid: App.id()}}
    #   ])

    # |> return(e)
    # |> Repo.all()
    # |> IO.inspect()
  end
end
