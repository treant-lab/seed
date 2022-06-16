defmodule Seed.Server.Entity do
  use GenServer
  alias Seed.Server.Entity.State

  def start_link(_args) do
    GenServer.start_link(Seed.Server.Entity, [], name: Entity)
  end

  def init(_args) do
    {:ok, State.initial_state()}
  end
end
