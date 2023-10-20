defmodule LiveChatWeb.MessageLive.Conversation do
  use LiveChatWeb, :live_view

  alias Phoenix.PubSub

  alias LiveChat.Chats
  alias LiveChat.Chats.Message

  @impl true
  def mount(_params, _session, socket) do
    new_form = to_form(Message.changeset(%Message{}, %{}))
    socket = assign(socket, form: new_form)

    if connected?(socket), do: subscribe()
    {:ok, stream(socket, :messages,  Chats.list_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  @impl true
  def handle_info({:message_created, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Chats.get_message!(id)
    {:ok, _} = Chats.delete_message(message)

    {:noreply, stream_delete(socket, :messages, message)}
  end



  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      %Message{}
      |> Chats.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
    def handle_event("save", %{"message" => message_params}, socket) do
    save_message(socket, :new, message_params)
  end


  defp save_message(socket, :new, message_params) do
    case Chats.create_message(message_params) do
      {:ok, message} ->
        new_form = to_form(Message.changeset(%Message{}, %{"name" => message_params["name"]}))
        notify(:message_created, message)
        {:noreply, socket|> assign(form: to_form(new_form))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify(:message_created, message) do
    PubSub.broadcast(LiveChat.PubSub, "liveview_chat", {:message_created, message})
  end

  defp subscribe() do
    PubSub.subscribe(LiveChat.PubSub, "liveview_chat")
  end
end
