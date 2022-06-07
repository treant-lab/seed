defmodule Seed.Roots.Repository.Reader do
  alias Seed.Database.Repo
  alias Seed.Roots.Schema.Root

  @spec get :: Root.t()
  def get() do
    Repo.Node.get!(Root, Seed.Settings.App.id())
  end
end
