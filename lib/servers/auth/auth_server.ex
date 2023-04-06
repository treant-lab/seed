defmodule Seed.Server.Auth do
  use GenServer
  alias Seed.Server.Auth.Imp

  def start_link(
        name: name,
        seed_id: id
      ) do
    GenServer.start_link(Seed.Server.Auth, [seed_id: id], name: name)
  end

  def init(args) do
    # IO.inspect(args)
    {:ok, args}
  end

  def handle_call(:count_auths, _from, seed_id: id = state) do
    total = Imp.get_total_users(id)

    {:reply, total, state}
  end

  def handle_call({:search, search}, _from, state) do
    data = Imp.search_users_by_email(state[:seed_id], search)

    {:reply, data, state}
  end

  @impl true
  def terminate(reason, state) do
    IO.inspect("terminate/2 callback")
    IO.inspect({:reason, reason})
    IO.inspect({:state, state})
  end
end
