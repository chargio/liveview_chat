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


  describe "Form" do


    test "name can't be blank", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
        |> form("#message-form")
        |> render_submit(%{name: "", content: "hello"}) =~ "can&#39;t be blank"
    end

    test "content can't be blank", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
        |> form("#message-form")
        |> render_submit(%{name: "Name", content: ""}) =~"can&#39;t be blank"
    end

    test "with both fields properly filled there is no error message", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      refute view
        |> form("#message-form", message: %{name: "Name", content: "Content"})
        |> render_submit() =~ "can&#39;t be blank"
    end
  end

  describe "Conversation" do
    setup [:create_message]

    test "lists all messages", %{conn: conn, message: message} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Liveview Chat"
      assert html =~ "Listing Messages"
      assert html =~ message.name
    end
  end
end
