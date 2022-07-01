defmodule Seed.Roots.Schema.Relationships.NoProps do
  import Seraph.Schema.Relationship
  alias Seed.Roots.Schema.Root
  alias Seed.Entities.Schema.Entity
  alias Seed.Authentication.Schema.User

  defrelationship("IS_ENTITY", Root, Entity, cardinality: [incoming: :many])
  defrelationship("IS_USER", User, Root, cardinality: [incoming: :many])
end
