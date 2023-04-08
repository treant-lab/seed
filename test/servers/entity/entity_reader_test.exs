defmodule EntityReaderServer do
  use ExUnit.Case, async: true

  test "should be possible get an entity by id." do
    id = Seed.Settings.App.id()
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    payload = %{
      name: "Example#{random_string}",
      color: "#ffffff"
    }

    assert {:ok, {module, _}} = Seed.Server.Entity.Client.create(id, payload)

    assert {:ok, {entity, _}} = Seed.Server.Entity.Client.get_by_id(id, module.id())
    assert entity.id() == module.id()
  end

  test "should be possible get all schemas using the server" do
    {:ok, schemas} = Seed.Server.Entity.Client.get_schemas(Seed.Settings.App.id())
  end
end
