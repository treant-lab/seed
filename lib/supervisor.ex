defmodule Seed.Supervisor do
  use Supervisor

  def start_link(state, args) do
    Supervisor.start_link(__MODULE__, state, args)
  end

  @impl true
  def init(seed_id: seed_id) do
    children = [
      Seed.Database.Repo,
      {Seed.Server.Repository, [name: :"Repository-#{seed_id}"]},
      {Seed.Server.Entity, [name: :"Repository-#{seed_id}"]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
