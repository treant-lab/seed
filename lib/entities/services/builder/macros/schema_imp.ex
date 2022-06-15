defmodule Seed.Entity.Services.Builder.Macros.Schema.Imp do
  alias Seed.Entities.Schema.Relationships.Field

  @spec get_field_type(Field.t()) :: atom()
  def get_field_type(field) do
    case field.type do
      "number" -> :integer
      "string" -> :string
      _ -> :string
    end
  end
end
