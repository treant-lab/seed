defmodule Seed.Server.User.Imp do
  alias Seed.Server.User
  alias Seed.Database.Repo
  alias Seed.Settings.App
  import Seraph.Query

  def authenticate({:authenticate, module, payload, _from} = _params) do
    Seed.Authentication.Services.Authenticator.call(payload)
  end
end
