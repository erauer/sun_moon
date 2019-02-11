defmodule SunMoon.Routine do
  @moduledoc false

  @sun {128, 64, 0}
  @moon {0, 0, 64}
  @off {0, 0, 0}

  require Logger

  def moon(), do: render(@moon)
  def sun(), do: render(@sun)
  def off(), do: render(@off)

  defp render(color) do
    Blinkchain.fill({0, 0}, 8, 4, color)
    Blinkchain.render()
  end
end
