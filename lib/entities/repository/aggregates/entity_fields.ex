defmodule Seed.Entities.Repository.Aggregates.Field do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  alias Seed.Entities.Schema.Relationships.Field
  alias Seed.Entities.Schema.Relationships.NoProps.EntityToField.IsField

  def create_fields(entity, fields) do
    with :ok <- includes_duplicated?(entity, fields),
         {:ok, fields} <- create_all_fields(fields),
         {:ok, _relations} <- create_is_field_relation_for_all(entity, fields) do
      {:ok, fields}
    else
      error -> {:error, error}
    end
  end

  defp get_name(map) do
    Map.get(map, "name", Map.get(map, :name, ""))
  end

  defp includes_duplicated?(entity, fields) do
    entity =
      entity
      |> Repo.Node.preload(:fields)

    entity_fields = entity.fields

    fields = entity_fields ++ fields

    names = Enum.map(fields, &get_name(&1))
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
    case is_all_valid?(fields) do
      true ->
        field_task_list = Enum.map(fields, &create_entity_field(&1))

        field_task_list
        |> Enum.to_list()
        |> handle_tasks_response()

      false ->
        {:error, {:invalid_field, fields}}
    end
  end

  defp is_all_valid?(fields) do
    Enum.all?(fields, fn field ->
      changeset = Field.changeset(%Field{}, field)
      changeset.valid?
    end)
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

    case entity_field_changeset.valid? do
      true -> Repo.Node.create(entity_field_changeset)
      false -> {:error, entity_field_changeset}
    end
  end

  def remove_field(root_id, entity_id, field_id) do
    Repo.query(
      """
      MATCH (r:Root {uuid: $root_id})
      MATCH (e:Entity {uuid: $entity_id})
      MATCH (f:Field {uuid: $field_id})
      DETACH DELETE f
      RETURN f
      """,
      %{
        root_id: root_id,
        entity_id: entity_id,
        field_id: field_id
      }
    )
    |> case do
      {:ok, [%{"f" => field}]} -> {:ok, field}
      _ -> {:error, "Invalid params"}
    end
  end
end
