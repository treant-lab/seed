defmodule Seed.Entities.Services.EntityBuilder do
  alias Seed.Database.Repo

  def call(entity) do
    entity =
      entity
      |> Repo.Node.preload(:fields)

    ast_module =
      defmodule :"#{entity.name}" do
        use Seed.Entity.Services.Builder.Macros.Schema, entity: entity
      end

    {:module, module, _, _} = ast_module

    {:ok, {module, ast_module}}
  end

  def call!(entity) do
    {:ok, module} = call(entity)
    module
  end
end
