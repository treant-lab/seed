defmodule Seed.Supervisor do
  use Supervisor

  def start_link(seed_id: id) do
    Supervisor.start_link(__MODULE__, [seed_id: id], name: :"Supervisor-#{id}")
  end

  @impl true
  def init(seed_id: seed_id) do
    children = [
      {Seed.Server.Repository, [name: :"Repository-#{seed_id}", seed_id: seed_id]},
      {Seed.Server.Entity, [name: :"Entity-#{seed_id}", seed_id: seed_id]},
      {Seed.Server.Auth, [name: :"Auth-#{seed_id}", seed_id: seed_id]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Seed.Supervisor.start_link([], [seed_id: "8d6023bc-d3ce-11ed-95f0-18c04df1b012"])
