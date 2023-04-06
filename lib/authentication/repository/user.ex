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

  def sign_in(email, password) do
    case get_by_email(email) do
      {:ok, user} ->
        if Bcrypt.verify_pass(password, user.password) do
          {:ok, user}
        else
          {:error, "Invalid password."}
        end

      err ->
        err
    end
  end

  def get_all_auths(uuid) do
    Repo.query(
      """
      MATCH (r:Root {uuid: $uuid})
      MATCH (r)-[:IS_USER]-(n)
      RETURN n
      """,
      %{uuid: uuid}
    )
    |> IO.inspect()
  end

  def get_total_users(uuid) do
    Repo.query(
      """
      MATCH (r:Root {uuid: $uuid})
      MATCH (r)-[:IS_USER]-(n)
      RETURN count(n) as count
      """,
      %{uuid: uuid}
    )
    |> case do
      {:ok, [%{"count" => count}]} -> count
      _ -> 0
    end
  end

  def search_users(uuid, search) do
    Repo.query(
      """
      MATCH (r:Root {uuid: $uuid})
      MATCH (r)-[:IS_USER]-(n:User)
      WHERE n.email CONTAINS $search
      RETURN n.uuid as uuid, n.email as email, LIMIT 10
      """,
      %{uuid: uuid, search: search}
    )
    |> IO.inspect()
  end
end
