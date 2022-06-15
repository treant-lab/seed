defmodule Seed.Entity.Services.Builder.Macros.Schema do
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use Seraph.Schema.Node
      import Seraph.Changeset
      import Seed.Entity.Services.Builder.Macros.Schema.Imp
      @entity Keyword.get(opts, :entity)

      node @entity.name do
        @entity.fields
        |> Enum.each(fn field ->
          property(String.to_atom(field.name), get_field_type(field))
        end)
      end
    end
  end
end
