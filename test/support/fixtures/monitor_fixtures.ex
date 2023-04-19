defmodule ApiMonitor.MonitorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ApiMonitor.Monitor` context.
  """

  @doc """
  Generate a endpoints.
  """
  def endpoints_fixture(attrs \\ %{}) do
    {:ok, endpoints} =
      attrs
      |> Enum.into(%{
        name: "some name",
        url: "some url"
      })
      |> ApiMonitor.Monitor.create_endpoints()

    endpoints
  end
end
