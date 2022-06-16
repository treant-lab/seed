defmodule Seed.Application do
  use Application

  def start(_type, _args) do
    children = [
      Seed.Database.Repo,
      Seed.Server.Repository,
      Seed.Server.Entity
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Seed.Application)
  end
end
