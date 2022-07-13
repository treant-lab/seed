defmodule Seed.Authentication.Services.Authenticator do
  alias Seed.Authentication.Schema.{User, Relationships.NoProps}
  alias Seed.Roots.Schema.Root
  alias Seed.Database.Repo
  alias Seed.Settings.App
  alias Seed.Authentication.Repository

  def call(params) do
    changeset = User.changeset(params)

    with {:ok, user} <- Repository.User.get_by_email(params.email),
         true <- Bcrypt.verify_pass(params.password, user.password) do
      {:ok, user}
    else
      _ -> {:error, "Wrong user or password."}
    end
  end
end
