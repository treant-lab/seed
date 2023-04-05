defmodule Seed.Supervisor do
  use Supervisor

  def start_link(state, args) do
    Supervisor.start_link(__MODULE__, state, args)
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
