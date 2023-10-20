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

  describe "Chat" do
    setup [:create_message]

    test "lists all messages", %{conn: conn, message: message} do
      {:ok, _index_live, html} = live(conn, ~p"/messages")

      assert html =~ "Listing Messages"
      assert html =~ message.name
    end

    test "saves new message", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/messages")

      assert index_live |> element("a", "New Message") |> render_click() =~
               "New Message"

      assert_patch(index_live, ~p"/messages/new")

      assert index_live
             |> form("#message-form", message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#message-form", message: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/messages")

      html = render(index_live)
      assert html =~ "Message created successfully"
      assert html =~ "some name"
    end

    test "updates message in listing", %{conn: conn, message: message} do
      {:ok, index_live, _html} = live(conn, ~p"/messages")

      assert index_live |> element("#messages-#{message.id} a", "Edit") |> render_click() =~
               "Edit Message"

      assert_patch(index_live, ~p"/messages/#{message}/edit")

      assert index_live
             |> form("#message-form", message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#message-form", message: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/messages")

      html = render(index_live)
      assert html =~ "Message updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes message in listing", %{conn: conn, message: message} do
      {:ok, index_live, _html} = live(conn, ~p"/messages")

      assert index_live |> element("#messages-#{message.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#messages-#{message.id}")
    end
  end
end
