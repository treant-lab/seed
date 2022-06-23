defmodule Seed.Util do
  def repository() do
    :"Repository-#{Seed.Settings.App.id()}"
  end

  def entity() do
    :"Entity-#{Seed.Settings.App.id()}"
  end
end
