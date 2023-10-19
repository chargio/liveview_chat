defmodule LiveChat.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :name, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
    |> validate_length(:name, min: 2)
    |> validate_length(:name, min: 2)
  end
end
