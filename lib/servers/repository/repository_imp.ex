defmodule Seed.Server.Repository.Imp do
  alias Seed.Server.Entity
  alias Seed.Database.Repo

  def insert({:insert, module, payload, _from} = _params) do
    module = Entity.Client.get_module(module)
    changeset = module.changeset(payload)

    Repo.Node.create(changeset)
  end
end
