defmodule UserSignIn do
  use ExUnit.Case, async: true
  alias Seed.Authentication.Services.{Creator, SignIn}

  test "should be possible create and sign in an new user." do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
    email = "#{random_string}@gmail.com"
    assert {:ok, user} = Creator.call(%{email: email, password: "pass@123!"})
    assert {:ok, token} = SignIn.call(email, "pass@123!")
    assert is_binary(token) == true
  end

  test "should return error when call signIn service with wrong params." do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
    email = "#{random_string}@gmail.com"
    assert {:ok, user} = Creator.call(%{email: email, password: "pass@123!"})
    assert {:ok, token} = SignIn.call(email, "pass@123!")
    assert is_binary(token) == true

    assert {:error, message} = SignIn.call(email, "pass@wrong")
  end

  test "should return error when call signIn service with wrong email param." do
    random_string = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
    email = "#{random_string}@gmail.com"
    assert {:ok, user} = Creator.call(%{email: email, password: "pass@123!"})
    assert {:ok, token} = SignIn.call(email, "pass@123!")
    assert is_binary(token) == true

    assert {:error, message} = SignIn.call("wrongemail@gmail.com", "pass@123!")
  end
end
