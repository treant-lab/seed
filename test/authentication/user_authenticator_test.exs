defmodule UserCreationTest do
  use ExUnit.Case, async: true
  alias Seed.Authentication.Services.Creator
  alias Seed.Authentication.Services.Authenticator

  setup do

    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    assert {:ok, user} = Creator.call(%{email: "#{random_string}@gmail.com", password: "pass@123!"})

    %{email: "#{random_string}@gmail.com"}
  end

  test "should authenticate an user from an application", %{email: email} do
    assert {:ok, _user} = Authenticator.call(%{email: email, password: "pass@123!"})
  end


  test "should return an error from authentication", %{email: email} do
    assert {:error, _user} = Authenticator.call(%{email: email, password: "wrong_password123"})
  end
end
