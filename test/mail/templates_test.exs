defmodule SeedTest.Mail.Templates do
  use ExUnit.Case, async: true

  test "should make an welcome customized email template" do
    assert {:ok, _content} =
             Seed.Mail.Sender.Templates.generate({:welcome, %{}})
  end

  test "should return an error of email template not found" do
    assert {:error, :template_not_found} =
             Seed.Mail.Sender.Templates.generate({:non_existent, %{}})
  end

  test "should return a template with replaced fields" do
    params = %{
      first_name: "Somebody",
      last_name: "Test",
      tier: "Tier Gold"
    }

    assert {:ok, content} = Seed.Mail.Sender.Templates.generate({:welcome, params})

    Map.keys(params)
    |> Enum.each(&assert content.template =~ params[&1])
  end
end
