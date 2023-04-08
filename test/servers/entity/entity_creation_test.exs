defmodule EntityCreationServer do
  use ExUnit.Case, async: true

  test "should be possible to create an entity calling the server." do
    id = Seed.Settings.App.id()
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    payload = %{
      name: "Example#{random_string}",
      color: "#ffffff"
    }

    previous_count = Seed.Server.Entity.Client.count(id)
    assert {:ok, schema} = Seed.Server.Entity.Client.create(id, payload)

    current_count = Seed.Server.Entity.Client.count(id)

    assert previous_count != current_count
  end

  test "should return error when try to create an entity calling the server" do
    id = Seed.Settings.App.id()
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    payload = %{
      name: "Entity#{random_string}"
    }

    assert {:error, _} = Seed.Server.Entity.Client.create(id, payload)
  end

  test "should be possible to create an entity without fields and add fields on it." do
    id = Seed.Settings.App.id()
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    payload = %{
      name: "Example#{random_string}",
      color: "#ffffff"
    }

    assert {:ok, {schema, _}} = Seed.Server.Entity.Client.create(id, payload)

    assert {:ok, field} =
             Seed.Server.Entity.Client.add_field(id, schema.id(), %{
               name: "username",
               type: "string",
               required: true
             })
  end

  test "should return a error when fields params is wrong." do
    id = Seed.Settings.App.id()
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    payload = %{
      name: "Example#{random_string}",
      color: "#ffffff"
    }

    assert {:ok, {schema, _}} = Seed.Server.Entity.Client.create(id, payload)

    assert {:error, _} =
             Seed.Server.Entity.Client.add_field(id, schema.id(), %{
               type: "string",
               required: true
             })
  end
end
