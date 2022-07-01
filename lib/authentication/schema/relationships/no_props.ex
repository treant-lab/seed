defmodule Seed.Authentication.Schema.Relationships.NoProps do
  import Seraph.Schema.Relationship
  alias Seed.Roots.Schema.Root
  alias Seed.Authentication.Schema.User

  defrelationship("IS_USER", User, Root, cardinality: [outgoing: :many])
end
