defmodule Seed.Settings.App do
  @spec id :: binary()
  def id() do
    Application.get_env(:seed, :app_id, "")
  end
end
