defmodule Seed.Server.Authentication.Client do
  def authenticate(module, payload, from) do
    GenServer.call(Seed.Util.authentication(), {:authenticate, module, payload, from})
  end
end
