defmodule SeedTest.Entity.Creation do
  use ExUnit.Case, async: true

  test "should be possible create an entity node using an creation service" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    assert {:ok, _entity} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example#{random_string}",
               color: "#ffffff"
             })
  end

  test "should return error when the entity already exists" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    assert {:ok, _entity} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example#{random_string}",
               color: "#ffffff"
             })

    assert {:error, :already_exists} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example#{random_string}",
               color: "#ffffff"
             })
  end

  test "should return error when the name is empty" do
    assert {:error, _entity} =
             Seed.Entities.Services.Creation.call(%{
               color: "#ffffff"
             })
  end
end
