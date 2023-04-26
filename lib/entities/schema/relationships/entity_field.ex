defmodule Seed.Entities.Schema.Relationships.Field do
  use Seraph.Schema.Node
  import Seraph.Changeset
  alias Seed.Entities.Schema.Entity
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

    incoming_relationship(
      "IS_FIELD",
      Entity,
      :owner,
      NoProps.EntityToField.IsField,
      cardinality: :one
    )
  end

  def changeset(node, params) do
    node
    |> cast(params, [:name, :type, :defaultValue, :required])
    |> validate_required([:name, :type, :required])
    |> check_name(:name)
    |> put_change(:createdAt, DateTime.truncate(DateTime.utc_now(), :second))
  end

  def is_camel_case(str) do
    Regex.match?(~r/^[a-z]+([A-Z][a-zA-Z]*)*$/, str)
  end

  defp check_name(changeset, field) do
    case is_camel_case(changeset.changes[field]) do
      true -> changeset
      false -> add_error(changeset, field, "should be camelCase.")
    end
  end
end
