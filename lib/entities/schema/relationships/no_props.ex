defmodule Seed.Entities.Schema.Relationships.NoProps do
  import Seraph.Schema.Relationship
  alias Seed.Roots.Schema.Root
  alias Seed.Entities.Schema.Entity

  defrelationship("IS_ENTITY", Root, Entity, cardinality: [outgoing: :many])
end
