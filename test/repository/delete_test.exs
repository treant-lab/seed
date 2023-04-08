defmodule SeedTest.Repository.Delete do
  use ExUnit.Case, async: true
  alias Seed.Entities.Repository.Aggregates.Field
  alias Seed.Database.Repo

  setup do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    fields = [
      %{name: "username", type: "string", required: true},
      %{name: "password", type: "string", required: true},
      %{name: "email", type: "string", required: true},
      %{name: "age", type: "number", required: true}
    ]

    name = "Example#{random_string}"

    {:ok, entity} =
      Seed.Entities.Services.Creation.call(
        %{
          name: name,
          color: "#ffffff",
          fields: fields
        },
        Seed.Settings.App.id()
      )

    %{name: name}
  end

  test "should be possible delete an entity data.", %{name: name} do
    assert {:ok, entity} =
             Seed.Server.Repository.Client.insert(
               Seed.Settings.App.id(),
               name,
               %{username: "Hello", password: "HEHEHE", email: "dev@dev.com", age: 20}
             )

    assert :ok = Seed.Server.Repository.Client.delete_by_id(Seed.Settings.App.id(), entity.uuid)
  end

  test "should be possible delete an entity data with soft delete option", %{name: name} do
    assert {:ok, entity} =
             Seed.Server.Repository.Client.insert(
               Seed.Settings.App.id(),
               name,
               %{username: "Hello", password: "HEHEHE", email: "dev@dev.com", age: 20}
             )

    assert {:ok, entity} =
             Seed.Server.Repository.Client.delete_by_id(Seed.Settings.App.id(), entity.uuid, true)

    assert entity = Repo.Node.preload(entity, :soft_deleted)
    assert entity.soft_deleted.uuid == Seed.Settings.App.id()
  end
end
