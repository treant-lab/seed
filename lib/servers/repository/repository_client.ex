defmodule Seed.Server.Repository.Client do
  def insert(module, payload, from) do
    GenServer.call(Seed.Util.repository(), {:insert, module, payload, from})
  end
end
