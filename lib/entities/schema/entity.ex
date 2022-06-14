defmodule Seed.Entities.Schema.Entity do
  use Seraph.Schema.Node
  import Seraph.Changeset
  alias Seed.Entities.Schema.Relationships.{NoProps, Field}

  @type t :: %{
          uuid: binary(),
          name: binary(),
          color: binary(),
          createdAt: DateTime.t(),
          updatedAt: DateTime.t()
        }

  node "Entity" do
    property(:name, :string)
    property(:color, :string)
    property(:createdAt, :utc_datetime)
    property(:updatedAt, :utc_datetime)

    incoming_relationship(
      "IS_ENTITY",
      Seed.Roots.Schema.Root,
      :root,
      NoProps.RootToEntity.IsEntity,
      cardinality: :one
    )

    outgoing_relationship(
      "IS_FIELD",
      Field,
      :fields,
      NoProps.EntityToField.IsField,
      cardinality: :many
    )

    outgoing_relationship(
      "IS_ROLE",
      Role,
      :roles,
      NoProps.RoleToEntity.IsRole,
      cardinality: :many
    )
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :color])
    |> validate_required([:name, :color])
    |> put_change(:createdAt, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
