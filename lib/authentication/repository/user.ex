defmodule Seed.Authentication.Repository.User do
  import Seraph.Query
  alias Seed.Authentication.Schema.{User, Relationships.NoProps}
  alias Seed.Roots.Schema.Root
  alias Seed.Database.Repo
  alias Seed.Settings.App

  def get_by_email(email) when is_binary(email) do
    match(
      [
        {u, User, %{email: email}},
        {r, Root, %{uuid: App.id()}},
        [{u}, [rel, NoProps.UserToRoot.IsUser, %{}], {r}]
      ],
      return: [u]
    )
    |> Repo.one()
    |> case do
      %{"u" => user} -> {:ok, user}
      _err -> nil
    end
  end

  def create_root_relation(user) do
    match(
      [
        {e, User, %{uuid: user.uuid}},
        {r, Root, %{uuid: App.id()}}
      ],
      create: [
        [{e}, [rel, NoProps.UserToRoot.IsUser, %{}], {r}]
      ],
      return: [rel]
    )
    |> Repo.one()
    |> case do
      %{"rel" => rel} -> {:ok, rel}
      err -> {:error, err}
    end
  end
end
