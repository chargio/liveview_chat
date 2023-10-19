defmodule LiveChat.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveChat.Chats` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        name: "some name"
      })
      |> LiveChat.Chats.create_message()

    message
  end
end
