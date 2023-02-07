defmodule SeedTest.Entity.Delete do
  use ExUnit.Case, async: true

  test "should be possible delete an entity node using the remove repository" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    assert {:ok, entity} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example#{random_string}",
               color: "#ffffff"
             })

    assert {:ok, entity} = Seed.Entities.Repository.Remover.by_id(entity.uuid)
  end

  test "should remove schema from state when the entity is removed" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    assert {:ok, entity} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example#{random_string}",
               color: "#ffffff"
             })

    schemas = Seed.Server.Entity.Client.get_schemas()
    assert Seed.Server.Entity.Client.exists?(entity.name) == true
    assert {:ok, entity} = Seed.Entities.Services.Remover.by_id(entity.uuid)
    schemas = Seed.Server.Entity.Client.get_schemas()
    assert Seed.Server.Entity.Client.exists?(entity.name) == false
  end
end
