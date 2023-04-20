defmodule ApiMonitor.MonitorDb do
  alias ApiMonitor.Monitor.Endpoints
  import Ecto.Query, warn: false
  alias ApiMonitor.Repo

  @doc """
  Returns the list of endpoint.

  ## Examples

      iex> list_endpoint()
      [%Endpoints{}, ...]

  """
  def list_endpoint do
    Repo.all(Endpoints)
  end

  @doc """
  Gets a single endpoints.

  Raises `Ecto.NoResultsError` if the Endpoints does not exist.

  ## Examples

      iex> get_endpoints!(123)
      %Endpoints{}

      iex> get_endpoints!(456)
      ** (Ecto.NoResultsError)

  """
  def get_endpoints!(id), do: Repo.get!(Endpoints, id)

  def get_endpoints(id), do: Repo.get(Endpoints, id)

  @doc """
  Creates a endpoints.

  ## Examples

      iex> create_endpoints(%{field: value})
      {:ok, %Endpoints{}}

      iex> create_endpoints(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_endpoints(attrs \\ %{}) do
    IO.inspect("creating.....")
    IO.inspect(attrs)

    %Endpoints{}
    |> Endpoints.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a endpoints.

  ## Examples

      iex> update_endpoints(endpoints, %{field: new_value})
      {:ok, %Endpoints{}}

      iex> update_endpoints(endpoints, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_endpoints(%Endpoints{} = endpoints, attrs) do
    endpoints
    |> Endpoints.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a endpoints.

  ## Examples

      iex> delete_endpoints(endpoints)
      {:ok, %Endpoints{}}

      iex> delete_endpoints(endpoints)
      {:error, %Ecto.Changeset{}}

  """
  def delete_endpoints(%Endpoints{} = endpoints) do
    Repo.delete(endpoints)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking endpoints changes.

  ## Examples

      iex> change_endpoints(endpoints)
      %Ecto.Changeset{data: %Endpoints{}}

  """
  def change_endpoints(%Endpoints{} = endpoints, attrs \\ %{}) do
    Endpoints.changeset(endpoints, attrs)
  end

  def get_endpoint_by_schedule(time) do
    Repo.all(from(e in Endpoints, where: e.schedule == ^time))
  end
end
