defmodule Seed.Server.Auth do
  use GenServer
  alias Seed.Server.Auth.Imp

  def start_link(
        name: name,
        seed_id: id = args
      ) do
    GenServer.start_link(Seed.Server.Auth, [seed_id: id], name: name)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:count_auths, _from, seed_id: id = state) do
    total = Imp.get_total_users(id)

    {:reply, total, state}
  end

  def handle_call({:search, search}, _from, seed_id: id = state) do
    total = Imp.search_users_by_email(id, search)

    {:reply, total, state}
  end
end
