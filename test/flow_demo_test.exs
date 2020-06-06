defmodule FlowDemoTest do
  use ExUnit.Case
  doctest FlowDemo

  test "greets the world" do
    assert FlowDemo.hello() == :world
  end
end
