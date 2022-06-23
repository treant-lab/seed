defmodule Seed.Entities.Services.EntityBuilder do
  alias Seed.Database.Repo

  def call(entity) do
    entity =
      entity
      |> Repo.Node.preload(:is_field)

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
