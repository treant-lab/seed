defmodule Seed.Entity.Services.Builder.Macros.Schema do
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use Seraph.Schema.Node
      import Seraph.Changeset
      import Seed.Entity.Services.Builder.Macros.Schema.Imp
      alias Seed.Roots.Schema.Root
      @entity Keyword.get(opts, :entity)
      entity_module = __MODULE__

      defmodule __MODULE__.IsData do
        use Seraph.Schema.Relationship

        @cardinality [outgoing: :one]

        relationship "IS_DATA" do
          start_node(entity_module)
          end_node(Root)
        end
      end

      defmodule __MODULE__.DeletedData do
        use Seraph.Schema.Relationship

        @cardinality [outgoing: :one]

        relationship "DELETED_DATA" do
          start_node(entity_module)
          end_node(Root)
        end
      end

      node @entity.name do
        @entity.fields
        |> Enum.each(fn field ->
          property(String.to_atom(field.name), get_field_type(field))
        end)

        outgoing_relationship(
          "IS_DATA",
          Root,
          :root,
          __MODULE__.IsData,
          cardinality: :one
        )

        outgoing_relationship(
          "DELETED_DATA",
          Root,
          :soft_deleted,
          __MODULE__.DeletedData,
          cardinality: :one
        )
      end

      def changeset(payload \\ %{}) do
        %__MODULE__{}
        |> cast(payload, get_cast_fields(@entity))
        |> validate_required(get_required_fields(@entity))
      end

      def changeset_update(entity, payload \\ %{}) do
        entity
        |> cast(payload, get_cast_fields(@entity))
      end

      def get_fields() do
        @entity.fields
      end

      def schema() do
        @entity
      end

      def id() do
        @entity.uuid
      end

      def name() do
        @entity.name
      end
    end
  end
end
