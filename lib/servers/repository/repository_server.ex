defmodule Seed.Server.Repository do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(Seed.Server.Repository, [], name: Repository)
  end

  def init(_args) do
    {:ok, []}
  end
end
