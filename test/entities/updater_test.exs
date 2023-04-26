defmodule SeedTest.Entity.Creation do
  use ExUnit.Case, async: true

  test "should be possible chamge the entity color" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    assert {:ok, entity} =
             Seed.Entities.Services.Creation.call(
               %{
                 name: "Example#{random_string}",
                 color: "#ffffff"
               },
               Seed.Settings.App.id()
             )

    assert {:ok, _} =
             Seed.Entities.Repository.Updater.update_color(
               Seed.Settings.App.id(),
               entity.uuid,
               "#cf3"
             )

    assert {:ok, entity} =
             Seed.Entities.Repository.Reader.by_id(Seed.Settings.App.id(), entity.uuid)
  end
end
