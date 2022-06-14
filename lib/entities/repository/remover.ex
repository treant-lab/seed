defmodule Seed.Entities.Repository.Remover do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  alias Seed.Entities.Schema.Relationships.NoProps.RootToEntity.IsEntity
  alias Seed.Roots.Schema.Root
  import Seraph.Query

  def by_id(uuid) when is_binary(uuid) do
    query =
      match([
        {r, Root, %{uuid: Seed.Settings.App.id()}},
        {entity, Entity, %{uuid: uuid}},
        [{r}, [rel, IsEntity], {entity}]
      ])
      |> return([entity])
      |> Repo.one()
      |> case do
        nil -> {:error, :invalid_id}
        %{"entity" => entity} -> Repo.Node.delete(entity)
      end
  end
end
