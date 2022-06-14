defmodule Seed.Entities.Repository.Aggregates.Field do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  alias Seed.Entities.Schema.Relationships.Field
  alias Seed.Entities.Schema.Relationships.NoProps.EntityToField.IsField

  @spec create_fields(Entity.t(), list(Field.t())) :: {:ok, list(Field.t())} | {:error, any()}
  def create_fields(entity, fields) do
    with {:ok, fields} <- create_all_fields(fields),
         {:ok, _relations} <- create_is_field_relation_for_all(entity, fields) do
      {:ok, fields}
    else
      error -> {:error, error}
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

    Task.async_stream(field_task_list, & &1.(), timeout: :infinity)
    |> Enum.to_list()
    |> handle_tasks_response()
  end

  defp handle_tasks_response(responses) do
    all_ok = Enum.all?(responses, &match?({:ok, {:ok, _}}, &1))

    if all_ok do
      only_task_values =
        responses
        |> Enum.map(fn {:ok, {:ok, value}} -> value end)

      {:ok, only_task_values}
    else
      {:error, :bad_params}
    end
  end

  defp create_entity_field(field) do
    fn ->
      entity_field_changeset = Field.changeset(%Field{}, field)

      Repo.Node.create(entity_field_changeset)
    end
  end
end
