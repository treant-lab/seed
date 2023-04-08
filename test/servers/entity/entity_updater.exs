defmodule EntityUpdaterServer do
  use ExUnit.Case, async: true

  test "should be possible remove a field from entity." do
    id = Seed.Settings.App.id()
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    payload = %{
      name: "Example#{random_string}",
      color: "#ffffff"
    }

    assert {:ok, {module, _}} = Seed.Server.Entity.Client.create(id, payload)

    assert {:ok, [field]} =
             Seed.Server.Entity.Client.add_field(id, module.id(), %{
               name: "username",
               type: "string",
               required: true
             })

    assert {:ok, field_removed} =
             Seed.Server.Entity.Client.remove_field_by_id(id, module.id(), field.uuid)
  end

  test "should return a error when try to remove a field from entity with invalid params" do
    id = Seed.Settings.App.id()
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    payload = %{
      name: "Example#{random_string}",
      color: "#ffffff"
    }

    assert {:ok, {module, _}} = Seed.Server.Entity.Client.create(id, payload)

    assert {:ok, [field]} =
             Seed.Server.Entity.Client.add_field(id, module.id(), %{
               name: "username",
               type: "string",
               required: true
             })

    assert {:error, _} = Seed.Server.Entity.Client.remove_field_by_id(id, module.id(), "wrongid")
  end
end
