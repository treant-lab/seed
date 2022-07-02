defmodule SeedTest.Repository.Insert do
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
             Seed.Entities.Services.Creation.call(%{
               name: name,
               color: "#ffffff",
               fields: fields
             })

    %{name: name}
  end

  test "should insert the data when the params is right", %{name: name} do

    assert {:ok, entity} = Seed.Server.Repository.Client.insert(name, %{username: "Hello", password: "HEHEHE", email: "dev@dev.com", age: 20}, self())
    entity = Repo.Node.preload(entity, :is_data)
    assert %Seed.Roots.Schema.Root{uuid: uuid} = entity.root
    assert uuid = Seed.Settings.App.id()
  end
end
