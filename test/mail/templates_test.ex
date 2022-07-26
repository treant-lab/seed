defmodule SeedTest.Mail.Templates do
  use ExUnit.Case, async: true

  test "should make an welcome customized email template" do
    assert {:ok, _template} = Seed.Mail.Sender.Templates.generate({:welcome, %{to: "somebody@email.com"}})
  end


  test "should return an error of email template not found" do
    assert {:error, :template_not_found} = Seed.Mail.Sender.Templates.generate({:non_existent, %{to: "somebody@email.com"}})
  end
end
