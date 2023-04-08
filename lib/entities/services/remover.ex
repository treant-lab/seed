defmodule Seed.Entities.Services.Remover do
  def by_id(app_id, uuid) when is_binary(uuid) do
    case Seed.Entities.Repository.Remover.by_id(app_id, uuid) do
      {:ok, entity} ->
        Seed.Server.Entity.Client.remove_schema(app_id, String.to_atom(entity.name))
        {:ok, entity}

      err ->
        err
    end
  end
end
