defmodule Seed.Entities.Repository.Creator do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  import Seraph.Query

  def exists?(name) do
    query =
      match(
        [
          {e, Entity, %{name: name}}
        ],
        return: [e]
      )

    Repo.one(query)
    |> case do
      nil -> false
      _ -> true
    end
  end
end
