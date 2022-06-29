defmodule SeedTest.Entity.FieldCreation do
  use ExUnit.Case, async: true
  alias Seed.Entities.Repository.Aggregates.Field
  alias Seed.Database.Repo

  test "should be possible create an entity field using an creation service" do
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
  end

  test "should return error when try to create an entity with invalid fields  " do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    assert {:error, _} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example#{random_string}",
               color: "#ffffff",
               fields: [
                 %{name: "username", type: "string", required: true},
                 %{name: "username", type: "string", required: true},
                 %{name: "email", type: "string", required: true},
                 %{name: "age", type: "number", required: true}
               ]
             })
             |> IO.inspect()
  end
end
