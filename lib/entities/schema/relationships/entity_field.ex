defmodule Seed.Entities.Schema.Relationships.Field do
  use Seraph.Schema.Node
  import Seraph.Changeset
  alias Seed.Entities.Schema.Relationships.{Field, NoProps}

  @type t :: %{
          name: binary(),
          type: binary(),
          defaultValue: binary(),
          required: boolean()
        }
  @derive {Jason.Encoder, only: [:uuid, :name, :type, :defaultValue, :required, :createdAt]}

  node "Field" do
    property(:name, :string)
    property(:type, :string)
    property(:defaultValue, :string)
    property(:required, :boolean)
    property(:createdAt, :utc_datetime)
    property(:updatedAt, :utc_datetime)

    outgoing_relationship(
      "IS_FIELD",
      Field,
      :is_field,
      NoProps.EntityToField.IsField,
      cardinality: :many
    )
  end

  def changeset(node, params) do
    node
    |> cast(params, [:name, :type, :defaultValue, :required])
    |> validate_required([:name, :type, :required])
    |> put_change(:createdAt, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
