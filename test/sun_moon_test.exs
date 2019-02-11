defmodule SunMoonTest do
  use ExUnit.Case
  doctest SunMoon

  test "greets the world" do
    assert SunMoon.hello() == :world
  end
end
