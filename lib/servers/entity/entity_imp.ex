defmodule Seed.Server.Entity.Imp do
  alias Seed.Entities.Repository.Reader
  alias Seed.Entities.Services.EntityBuilder

  @spec get_all_schemas :: list(Seraph.Schema.t())
  def get_all_schemas() do
    schemas =
      Reader.all()
      |> Parallel.pmap(&EntityBuilder.call!/1)

    schemas
  end

  def get(name, schemas) do
    atom_name = String.to_atom(name)

    Enum.find(schemas, fn schema ->
      schema == atom_name
    end)
  end
end
