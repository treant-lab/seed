defmodule Seed.Authentication.Services.Creator do
  alias Seed.Authentication.Schema.{User, Relationships.NoProps}
  alias Seed.Roots.Schema.Root
  alias Seed.Database.Repo
  alias Seed.Settings.App
  alias Seed.Authentication.Repository

  def call(params) do
    changeset = User.changeset(params)

    with nil <- Repository.User.get_by_email(params.email),
         {:ok, user} <- Repo.Node.create(changeset),
         {:ok, _rel} <- Repository.User.create_root_relation(user) do
      {:ok, user}
    else
      {:error, err} -> {:error, err}
      {:ok, user} when is_struct(user, User) -> {:error, "E-mail already in use."}
    end
  end
end
