defmodule Seed.Entities.Schema.Relationships.NoProps do
  import Seraph.Schema.Relationship
  alias Seed.Roots.Schema.Root
  alias Seed.Entities.Schema.{Entity, Relationships.Field, Relationships.Role}

  defrelationship("IS_FIELD", Entity, Field, cardinality: [incoming: :many])
  defrelationship("IS_ROLE", Role, Entity, cardinality: [incoming: :many])
  defrelationship("IS_ENTITY", Root, Entity, cardinality: [incoming: :one])
end
