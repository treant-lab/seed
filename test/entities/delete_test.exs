defmodule SeedTest.Entity.Delete do
  use ExUnit.Case, async: false

  test "should be possible delete an entity node using the remove repository" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
    id = Seed.Settings.App.id()

    assert {:ok, {entity, _}} =
             Seed.Server.Entity.Client.create(
               id,
               %{
                 name: "Example#{random_string}",
                 color: "#ffffff"
               }
             )

    assert {:ok, entity} = Seed.Entities.Repository.Remover.by_id(id, entity.id())
  end

  test "should remove schema from state when the entity is removed" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
    id = Seed.Settings.App.id()

    assert {:ok, {entity, _}} =
             Seed.Server.Entity.Client.create(
               id,
               %{
                 name: "Example#{random_string}",
                 color: "#ffffff"
               }
             )

    assert Seed.Server.Entity.Client.exists?(id, entity.name()) == true
    assert {:ok, entity} = Seed.Entities.Services.Remover.by_id(id, entity.id())
    assert Seed.Server.Entity.Client.exists?(id, entity.name()) == false
  end
end
