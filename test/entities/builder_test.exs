defmodule SeedTest.Entities.Builder do
  use ExUnit.Case, async: true
  alias Seed.Entities.Repository.Aggregates.Field

  test "must create an entity schmema module by entity uuid" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>


    assert {:ok, entity} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example#{random_string}",
               color: "#ffffff",
               fields: [
                %{name: "username", type: "string", required: true},
                %{name: "password", type: "string", required: true},
                %{name: "email", type: "string", required: true},
                %{name: "age", type: "number", required: true}
              ]
             })

    assert {:ok, module} = Seed.Entities.Services.EntityBuilder.call(entity)

    assert Enum.count([:uuid, :age, :email, :password, :username]) ==
             Enum.count(module.__schema__(:properties))

    assert module.changeset(%{}).valid? == false
  end
end
