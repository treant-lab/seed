defmodule SeedTest.Repository.Update do
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

  test "should be possible update an entity data.", %{name: name} do
    assert {:ok, entity} =
             Seed.Server.Repository.Client.insert(
               Seed.Settings.App.id(),
               name,
               %{username: "Hello", password: "HEHEHE", email: "dev@dev.com", age: 20}
             )

    assert {:ok, entity} =
             Seed.Server.Repository.Client.update_by_id(
               Seed.Settings.App.id(),
               name,
               entity.uuid,
               %{
                 username: "hello updated!",
                 password: "hello pass"
               }
             )

    assert entity.username == "hello updated!"

    assert entity.password == "hello pass"
  end

  test "should be not possible add new fields using update_by_id", %{name: name} do
    assert {:ok, entity} =
             Seed.Server.Repository.Client.insert(
               Seed.Settings.App.id(),
               name,
               %{username: "Hello", password: "HEHEHE", email: "dev@dev.com", age: 20}
             )

    assert {:ok, entity} =
             Seed.Server.Repository.Client.update_by_id(
               Seed.Settings.App.id(),
               name,
               entity.uuid,
               %{
                 newfielddata: "hello updated!"
               }
             )

    assert Map.has_key?(entity, :newfielddata) == false
  end
end
