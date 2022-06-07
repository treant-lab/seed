defmodule Seed.Entities.Services.Creation do
  alias Seed.Entities.Repository.Reader
  alias Seed.Entities.Schema.Entity
  alias Seed.Database.Repo

  def call(params \\ %{}) do
    with name when is_binary(name) <- Map.get(params, :name, nil),
         false <- Reader.exists?(name),
         changeset <- Entity.changeset(params),
         {:ok, entity} <- Repo.Node.create(changeset) do
      {:ok, entity}
    else
      nil -> {:error, "empty name"}
      true -> {:error, "Invalid name"}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
