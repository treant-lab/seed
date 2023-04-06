defmodule Seed.Application do
  use Application

  def start(_type, _args) do
    seed_id = Application.get_env(:seed, :app_id)

    children = [
      Seed.Database.Repo,
      {Seed.Server.Repository, [name: :"Repository-#{seed_id}", seed_id: seed_id]},
      {Seed.Server.Entity, [name: :"Entity-#{seed_id}", seed_id: seed_id]},
      {Seed.Server.Auth, [name: :"Auth-#{seed_id}", seed_id: seed_id]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end

  # def start(_type, seed_uuid: seed_id) do
  #   children = [
  #     Seed.Database.Repon,
  #     {Seed.Server.Repository, [name: :"Repository-#{seed_id}"]},
  #     {Seed.Server.Entity, [name: :"Entity-#{seed_id}"]}
  #   ]

  #   Supervisor.start_link(children, strategy: :one_for_one, name: :"#{seed_id}")
  # end
end
