defmodule Seed.Entities.Services.EntityBuilder do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity

  def call(entity) do
    entity =
      entity
      |> Repo.Node.preload(:fields)

    {:module, module, _, _} =
      defmodule :"#{entity.name}" do
        use Seed.Entity.Services.Builder.Macros.Schema, entity: entity
      end

    {:ok, module}
  end

  def call!(entity) do
    {:ok, module} = call(entity)
    module
  end
end
