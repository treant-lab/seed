defmodule Seed.Server.Authentication do
  use GenServer
  alias Seed.Server.Authentication.Imp

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_args) do
    GenServer.start_link(Seed.Server.Authentication, [], name: Seed.Util.authentication())
  end

  def init(_args) do
    {:ok, []}
  end

  def handle_call({:authenticate, module, payload, from}, _from, state) do
    response = Imp.authenticate({:authenticate, module, payload, from})

    {:reply, response, state}
  end
end
