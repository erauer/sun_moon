defmodule SunMoon.TimeMonitor do
  use GenServer

  @moduledoc false

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_) do
    {:ok, %{}, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, state) do
    schedule_check()
    {:noreply, state}
  end

  @impl true
  def handle_info(:check, state) do
    if Nerves.Time.synchronized?() do
      SunMoon.Application.start_routine()
    else
      schedule_check()
    end

    {:noreply, state}
  end

  defp schedule_check() do
    Process.send_after(self(), :check, 1_000)
  end
end
