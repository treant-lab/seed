defmodule Seed.DynamicSupervisor do
  use DynamicSupervisor

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(seed_id) do
    spec = {Seed.Supervisor, seed_id: seed_id}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end

#
# Seed.DynamicSupervisor.start_child("8d6023bc-d3ce-11ed-95f0-18c04df1b012")
