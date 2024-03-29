defmodule PhoenixTherapist.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixTherapist.Notes` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        description: "some description"
      })
      |> PhoenixTherapist.Notes.create_note()

    note
  end
end
