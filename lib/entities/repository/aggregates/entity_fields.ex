defmodule Seed.Entities.Repository.Aggregates.Field do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  alias Seed.Entities.Schema.Relationships.Field
  alias Seed.Entities.Schema.Relationships.NoProps.EntityToField.IsField

  @spec create_fields(Entity.t(), list(Field.t())) :: {:ok, list(Field.t())} | {:error, any()}
  def create_fields(entity, fields) do
    with :ok <- includes_duplicated?(fields),
         {:ok, fields} <- create_all_fields(fields),
         {:ok, relations} <- create_is_field_relation_for_all(entity, fields) do
      {:ok, fields}
    else
      error -> {:error, error}
    end
  end

  defp includes_duplicated?(fields) do
    names = Enum.map(fields, & &1.name)
    duplicated_names = names -- Enum.uniq(names)

    case duplicated_names do
      [] -> :ok
      _ -> {:error, duplicated_names}
    end
  end

  defp create_is_field_relation_for_all(entity, entity_field_list) do
    creation_list =
      Enum.map(entity_field_list, fn entity_field ->
        data = %IsField{
          start_node: entity,
          end_node: entity_field
        }

        Repo.Relationship.create(data)
      end)

    creation_list
    |> Enum.all?(fn {status, _} -> status == :ok end)
    |> case do
      true -> {:ok, creation_list}
      _ -> {:error, creation_list}
    end
  end

  defp create_all_fields(fields) do
    field_task_list = Enum.map(fields, &create_entity_field(&1))

    field_task_list
    |> Enum.to_list()
    |> handle_tasks_response()
  end

  defp handle_tasks_response(responses) do
    all_ok = Enum.all?(responses, &match?({:ok, _}, &1))

    if all_ok do
      only_task_values =
        responses
        |> Enum.map(fn {:ok, value} -> value end)

      {:ok, only_task_values}
    else
      {:error, {:bad_params, responses}}
    end
  end

  defp create_entity_field(field) do
    entity_field_changeset = Field.changeset(%Field{}, field)

    Repo.Node.create(entity_field_changeset)
  end
end
