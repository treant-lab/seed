defmodule Seed.Entities.Schema.Relationships.Role do
  use Seraph.Schema.Node
  import Seraph.Changeset
  alias Seed.Entities.Schema.Relationships.{Role, NoProps}

  node "Role" do
    property :name, :string

    incoming_relationship(
      "IS_ROLE",
      Role,
      :is_role,
      NoProps.RoleToEntity.IsRole,
      cardinality: :one
    )
  end
end
