defmodule Seed.Entities.Schema.Builder do
  alias Seed.Entities.Repository.Reader
  alias Seed.Database.Repo

  def by_id(uuid) do
    {:ok, entity} = Reader.by_id(uuid)

    entity =
      entity
      |> Repo.Node.preload(:fields)
  end
end
