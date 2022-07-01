defmodule UserCreationTest do
    use ExUnit.Case, async: true
    alias Seed.Authentication.Services.Creator

    test "should create an user with root relationship" do
      random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

      assert {:ok, user} = Creator.call(%{email: "#{random_string}@gmail.com", password: "pass@123!"})
    end

    test "should prevent to create an user when already exists with same email" do
      random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

      assert {:ok, user} = Creator.call(%{email: "#{random_string}@gmail.com", password: "pass@123!"})
      assert {:error, "E-mail already in use."} = Creator.call(%{email: "#{random_string}@gmail.com", password: "pass@123!"})
    end
end
