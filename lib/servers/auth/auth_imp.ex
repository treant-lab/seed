defmodule Seed.Server.Auth.Imp do
  def get_all_schemas() do
    Seed.Authentication.Repository.User.get_all_auths()
    |> IO.inspect()

    []
  end

  def get(name, schemas) do
    atom_name = String.to_atom(name)

    Enum.find(schemas, fn {schema, _} ->
      schema == atom_name
    end)
  end

  def exists?(name, schemas) do
    atom_name = String.to_atom(name)

    Enum.find(schemas, fn {schema, _} ->
      schema == atom_name
    end)
    |> case do
      nil -> false
      _ -> true
    end
  end

  def get_total_users(id) do
    Seed.Authentication.Repository.User.get_total_users(id)
  end

  def search_users_by_email(id, search) do
    Seed.Authentication.Repository.User.search_users(id, search)
  end
end
