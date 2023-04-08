defmodule Seed.Entities.Services.Creation do
  alias Seed.Entities.Repository.Reader
  alias Seed.Entities.Schema.Entity
  alias Seed.Roots.Schema.{Root, Relationships.NoProps.RootToEntity.IsEntity}

  alias Seed.Database.Repo
  import Seraph.Query
  alias Seed.Entities.Repository.Aggregates.Field

  def call(params) do
    call(params, Seed.Settings.App.id())
  end

  @spec call(map(), binary()) :: {:ok, Entity.t()} | {:error, any}
  def call(params, root_id) do
    fields = Map.get(params, :fields, [])

    with name when is_binary(name) <- get_name(params),
         false <- Reader.exists?(name),
         changeset <- Entity.changeset(params),
         {:ok, entity} <- Repo.Node.create(changeset),
         {:ok, _relation} <- create_root_relation(entity, root_id),
         {:ok, _fields} <- Field.create_fields(entity, fields) do
      push_schema_to_entity(entity, root_id)
      {:ok, entity}
    else
      nil -> {:error, :empty_name}
      true -> {:error, :already_exists}
      {:error, {:bad_params, fields_with_error}} -> delete_nodes_with_error(fields_with_error)
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp get_name(params) do
    Map.get(params, "name", Map.get(params, :name, nil))
  end

  defp delete_nodes_with_error(fields_with_error) do
    {:error, :bad_params}
  end

  defp push_schema_to_entity(entity, root_id) do
    module = Seed.Entities.Services.EntityBuilder.call!(entity)
    Seed.Server.Entity.Client.push_schema(root_id, module)
  end

  defp create_root_relation(entity, root_id) do
    match(
      [
        {e, Entity, %{uuid: entity.uuid}},
        {r, Root, %{uuid: root_id}}
      ],
      create: [
        [{r}, [rel, IsEntity, %{}], {e}]
      ],
      return: [rel]
    )
    |> Repo.one()
    |> case do
      %{"rel" => rel} -> {:ok, rel}
      err -> {:error, err}
    end
  end
end
