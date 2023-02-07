defmodule Seed.Authentication.Services.SignIn do
  alias Seed.Authentication.Schema.{User, Relationships.NoProps}
  alias Seed.Roots.Schema.Root
  alias Seed.Database.Repo
  alias Seed.Settings.App
  alias Seed.Authentication.Repository

  def call(email, password) do
    case Repository.User.sign_in(email, password) do
      {:ok, user} ->
        token =
          Seed.Token.generate_and_sign!(%{
            "user_uuid" => user.uuid,
            "user_email" => user.email
          })

        {:ok, token}

      _ ->
        {:error, "Invalid email or password."}
    end
  end
end
