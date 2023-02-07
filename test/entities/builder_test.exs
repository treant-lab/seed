defmodule SeedTest.Entities.Builder do
  use ExUnit.Case, async: true
  alias Seed.Entities.Repository.Aggregates.Field
  import Seraph.Query

  test "must create an entity schmema module by entity uuid" do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    {:ok, entity} =
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

    {module, ast_module} = Seed.Server.Entity.Client.get_module("Example#{random_string}")
    # |> IO.inspect()
    # :beam_disasm.function__code()
    # |> IO.inspect()
    # ast_module = Macro.escape(ast_module)
    # IO.inspect(ast_module.__schema__(:primary_label))
    # Seed.Server.Entity.Client.get_schemas()
    # |> IO.inspect()
    # scape = Macro.expand(ast_module, __CALLER__)
    # |> IO.inspect()
    # escape = Macro.escape(ast_module)
    #         IO.inspect(escape)
    # IO.inspect(module.__schema__(:primary_label))

    # quote, do: Seed.Roots.Schema.Root
    # |> IO.inspect()
    # match([
    #   {n, ast_module}
    # ],
    # return: [n])
    # |>
    # IO.inspect()
    # IO.inspect({:module, })
    # assert {:ok, module} = Seed.Entities.Services.EntityBuilder.call(entity)

    # assert Enum.count([:uuid, :age, :email, :password, :username]) ==
    #          Enum.count(module.__schema__(:properties))

    # assert module.changeset(%{}).valid? == false
  end
end
