defmodule SeedTest.Mail.Templates do
  use ExUnit.Case, async: true

  test "should make an welcome customized email template" do
    assert {:ok, _template} = Seed.Mail.Sender.Templates.generate({:welcome, %{to: "somebody@email.com"}})
  end

  #TODO: Create error when template is not found
end
