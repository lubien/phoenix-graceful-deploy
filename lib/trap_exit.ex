defmodule AppHealth do
  use GenServer

  # Initial state of the application health
  @initial_state true

  # GenServer callbacks
  def start_link(_) do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end

  def init(_state) do
    {:ok, @initial_state}
  end

  # Handle the 'down' command to set the application health to false
  def down do
    GenServer.cast(__MODULE__, :down)
  end

  # Handle the 'status' command to retrieve the current application health
  def healthy? do
    GenServer.call(__MODULE__, :status)
  end

  # GenServer callback to handle down command
  def handle_cast(:down, _state) do
    {:noreply, false}
  end

  # GenServer callback to handle status command
  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end
end
