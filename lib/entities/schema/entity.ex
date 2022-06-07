defmodule Seed.Entities.Schema.Entity do
  use Seraph.Schema.Node
  import Seraph.Changeset

  node "Entity" do
    property(:name, :string)
    property(:color, :string)
    property(:createdAt, :utc_datetime)
    property(:updatedAt, :utc_datetime)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :color])
    |> validate_required([:name, :color])
  end
end
