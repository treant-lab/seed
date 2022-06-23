defmodule Seed.Entities.Services.Creation do
  alias Seed.Entities.Repository.Reader
  alias Seed.Entities.Schema.Entity
  alias Seed.Roots.Schema.{Root, Relationships.NoProps.RootToEntity.IsEntity}
  alias Seed.Settings.App
  alias Seed.Database.Repo
  import Seraph.Query
  alias Seed.Entities.Repository.Aggregates.Field


  @spec call(map) :: {:ok, Entity.t()} | {:error, any}
  def call(params \\ %{}) do
    fields = Map.get(params, :fields, [])
    with name when is_binary(name) <- Map.get(params, :name, nil),
         false <- Reader.exists?(name),
         changeset <- Entity.changeset(params),
         {:ok, entity} <- Repo.Node.create(changeset),
         {:ok, _relation} <- create_root_relation(entity),
         {:ok, fields} <- Field.create_fields(entity, fields) do
      push_schema_to_entity(entity)
      {:ok, entity}
    else
      nil -> {:error, :empty_name}
      true -> {:error, :already_exists}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp push_schema_to_entity(entity) do
    module = Seed.Entities.Services.EntityBuilder.call!(entity)
    Seed.Server.Entity.Client.push_schema(module)
  end

  defp create_root_relation(entity) do
    match(
      [
        {e, Entity, %{uuid: entity.uuid}},
        {r, Root, %{uuid: App.id()}}
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
