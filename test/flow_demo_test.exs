defmodule FlowDemoTest do
  use ExUnit.Case
  doctest FlowDemo

  @moduletag timeout: :infinity

  test "start_sync" do
    :timer.tc(fn ->
      FlowDemo.start_sync()
      :ok
    end)
    |> IO.inspect(label: "sync")
  end

  test "start" do
    :timer.tc(fn ->
      FlowDemo.start()
      :ok
    end)
    |> IO.inspect(label: "async")
  end
end
