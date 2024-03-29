defmodule PhoenixTherapistWeb.NoteLive.Index do
  use PhoenixTherapistWeb, :live_view

  alias PhoenixTherapist.Notes
  alias PhoenixTherapist.Notes.Note

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :notes, list_notes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, Notes.get_note!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, %Note{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Notes")
    |> assign(:note, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    {:noreply, assign(socket, :notes, list_notes())}
  end

  defp list_notes do
    Notes.list_notes()
  end
end
