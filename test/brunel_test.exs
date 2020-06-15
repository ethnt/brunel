defmodule BrunelTest do
  use ExUnit.Case
  doctest Brunel

  test "greets the world" do
    assert Brunel.hello() == :world
  end
end
