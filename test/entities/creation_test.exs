defmodule SeedTest.Entity.Creation do
  use ExUnit.Case, async: true

  test "should be possible create an entity node using an creation service" do
    assert {:ok, entity} =
             Seed.Entities.Services.Creation.call(%{
               name: "Example",
               color: "#ffffff"
             })
  end
end
