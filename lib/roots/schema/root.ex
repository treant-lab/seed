defmodule Seed.Roots.Schema.Root do
  use Seraph.Schema.Node
  import Seraph.Changeset

  @type t :: %{
          uuid: binary(),
          name: binary(),
          rsaPrivate: binary(),
          rsaPublic: binary(),
          createdAt: DateTime.t(),
          updatedAt: DateTime.t()
        }

  node "Root" do
    property(:name, :string)
    property(:rsaPrivate, :string)
    property(:rsaPublic, :string)
    property(:createdAt, :utc_datetime)
    property(:updatedAt, :utc_datetime)
  end

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> cast(params, [:name])
    |> validate_required([:name])
    |> put_rsa_keys()
    |> put_change(:createdAt, DateTime.truncate(DateTime.utc_now(), :second))
  end

  defp put_rsa_keys(changeset) do
    {:ok, {priv, pub}} = RsaEx.generate_keypair()

    changeset
    |> put_change(:rsaPrivate, priv)
    |> put_change(:rsaPublic, pub)
  end
end
