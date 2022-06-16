defmodule Seed.Entity.Services.Builder.Macros.Schema.Imp do
  alias Seed.Entities.Schema.Relationships.Field
  alias Seed.Entities.Schema.Entity

  @spec get_field_type(Field.t()) :: atom()
  def get_field_type(field) do
    case field.type do
      "number" -> :integer
      "string" -> :string
      _ -> :string
    end
  end

  def get_cast_fields(entity) do
    entity.fields
    |> Enum.map(&String.to_atom(&1.name))
  end

  def get_required_fields(%Entity{} = entity) do
    entity.fields
    |> Enum.filter(&(&1.required == true))
    |> Enum.map(&String.to_atom(&1.name))
  end
end
