defmodule Seed.Entities.Services.EntityBuilder do
  alias Seed.Entities.Repository.Reader
  alias Seed.Database.Repo

  def by_id(uuid) do
    {:ok, entity} = Reader.by_id(uuid)

    entity =
      entity
      |> Repo.Node.preload(:fields)

    {:module, module, _, _} =
      defmodule :"#{entity.name}" do
        use Seed.Entity.Services.Builder.Macros.Schema, entity: entity
      end

    {:ok, module}
  end
end
