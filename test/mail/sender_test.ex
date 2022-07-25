defmodule SeedTest.Mail.Sender do
  use ExUnit.Case, async: true

  test "should send an welcome customized email template" do
    email = Seed.Mail.Sender.send_default_template({:welcome, %{to: "somebody@email.com"}})
    assert email.to == "somebody@email.com"
  end

  #TODO: Create error cases
end
