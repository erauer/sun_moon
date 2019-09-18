defmodule SunMoon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SunMoon.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    children(nil)
  end

  def children(_target) do
    [
      {DynamicSupervisor, name: SunMoon.RoutineSupervisor, strategy: :one_for_one},
      SunMoon.TimeMonitor
    ]
  end

  def start_routine() do
    {:ok, _pid} =
      DynamicSupervisor.start_child(
        SunMoon.RoutineSupervisor,
        %{
          id: "moon1",
          start:
            {SchedEx, :run_every,
             [&SunMoon.Routine.moon/0, "40 6 * * 1-5", [timezone: "America/Los_Angeles"]]}
        }
      )

    DynamicSupervisor.start_child(
      SunMoon.RoutineSupervisor,
      %{
        id: "moon2",
        start:
          {SchedEx, :run_every,
           [&SunMoon.Routine.moon/0, "40 7 * * 6,0", [timezone: "America/Los_Angeles"]]}
      }
    )

    {:ok, _pid} =
      DynamicSupervisor.start_child(
        SunMoon.RoutineSupervisor,
        %{
          id: "sun1",
          start:
            {SchedEx, :run_every,
             [&SunMoon.Routine.sun/0, "45 6 * * 1-5", [timezone: "America/Los_Angeles"]]}
        }
      )

    {:ok, _pid} =
      DynamicSupervisor.start_child(
        SunMoon.RoutineSupervisor,
        %{
          id: "sun2",
          start:
            {SchedEx, :run_every,
             [&SunMoon.Routine.sun/0, "45 7 * * 6,0", [timezone: "America/Los_Angeles"]]}
        }
      )

    {:ok, _pid} =
      DynamicSupervisor.start_child(
        SunMoon.RoutineSupervisor,
        %{
          id: "off",
          start:
            {SchedEx, :run_every,
             [&SunMoon.Routine.off/0, "30 * * * *", [timezone: "America/Los_Angeles"]]}
        }
      )
  end
end
