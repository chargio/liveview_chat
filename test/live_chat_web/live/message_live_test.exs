defmodule LiveChatWeb.MessageLiveTest do
  use LiveChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveChat.ChatsFixtures

  @create_attrs %{name: "some name", content: "some content"}
  @update_attrs %{name: "some updated name", content: "some updated content"}
  @invalid_attrs %{name: nil, content: nil}

  defp create_message(_) do
    message = message_fixture()
    %{message: message}
  end

  describe "Conversation" do
    setup [:create_message]

    test "lists all messages", %{conn: conn, message: message} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Messages"
      assert html =~ message.name
    end

    test "new message", %{conn: conn} do
    end
  end
end
