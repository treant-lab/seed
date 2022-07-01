defmodule Seed.Authentication.Schema.User do
  use Seraph.Schema.Node
  import Seraph.Changeset
  alias Seed.Roots.Schema.Root
  alias Seed.Authentication.Schema.Relationships.NoProps

  @type t :: %{
    uuid: binary(),
    email: binary(),
    password: binary(),
    createdAt: DateTime.t(),
    updatedAt: DateTime.t()
  }

  node "User" do
    property(:email, :string)
    property(:password, :string)
    property(:createdAt, :utc_datetime)
    property(:updatedAt, :utc_datetime)
  end

  outgoing_relationship(
      "IS_USER",
      Root,
      :root,
      NoProps.UserToRoot.IsUser,
      cardinality: :many
  )

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> put_change(:password, Bcrypt.hash_pwd_salt(params.password))
    |> put_change(:createdAt, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
