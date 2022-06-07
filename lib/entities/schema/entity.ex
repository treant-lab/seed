defmodule Seed.Entities.Schema.Entity do
  use Seraph.Schema.Node
  import Seraph.Changeset

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
    incoming_relationship("IS_ENTITY", Seed.Roots.Schema.Root, :root, Seed.Entities.Schema.Relationships.NoProps.RootToEntity.IsEntity, cardinality: :one)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :color])
    |> validate_required([:name, :color])
    |> put_change(:createdAt, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
