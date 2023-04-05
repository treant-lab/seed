defmodule Seed.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: args["name"])
  end

  @impl true
  def init(_init_arg) do
    children = [
      Seed.Database.Repo,
      Seed.Server.Repository,
      Seed.Server.Entity
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
