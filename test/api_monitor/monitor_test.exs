defmodule ApiMonitor.MonitorTest do
  use ApiMonitor.DataCase

  alias ApiMonitor.Monitor

  describe "endpoint" do
    alias ApiMonitor.Monitor.Endpoints

    import ApiMonitor.MonitorFixtures

    @invalid_attrs %{name: nil, url: nil}

    test "list_endpoint/0 returns all endpoint" do
      endpoints = endpoints_fixture()
      assert Monitor.list_endpoint() == [endpoints]
    end

    test "get_endpoints!/1 returns the endpoints with given id" do
      endpoints = endpoints_fixture()
      assert Monitor.get_endpoints!(endpoints.id) == endpoints
    end

    test "create_endpoints/1 with valid data creates a endpoints" do
      valid_attrs = %{name: "some name", url: "some url"}

      assert {:ok, %Endpoints{} = endpoints} = Monitor.create_endpoints(valid_attrs)
      assert endpoints.name == "some name"
      assert endpoints.url == "some url"
    end

    test "create_endpoints/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitor.create_endpoints(@invalid_attrs)
    end

    test "update_endpoints/2 with valid data updates the endpoints" do
      endpoints = endpoints_fixture()
      update_attrs = %{name: "some updated name", url: "some updated url"}

      assert {:ok, %Endpoints{} = endpoints} = Monitor.update_endpoints(endpoints, update_attrs)
      assert endpoints.name == "some updated name"
      assert endpoints.url == "some updated url"
    end

    test "update_endpoints/2 with invalid data returns error changeset" do
      endpoints = endpoints_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitor.update_endpoints(endpoints, @invalid_attrs)
      assert endpoints == Monitor.get_endpoints!(endpoints.id)
    end

    test "delete_endpoints/1 deletes the endpoints" do
      endpoints = endpoints_fixture()
      assert {:ok, %Endpoints{}} = Monitor.delete_endpoints(endpoints)
      assert_raise Ecto.NoResultsError, fn -> Monitor.get_endpoints!(endpoints.id) end
    end

    test "change_endpoints/1 returns a endpoints changeset" do
      endpoints = endpoints_fixture()
      assert %Ecto.Changeset{} = Monitor.change_endpoints(endpoints)
    end
  end
end
