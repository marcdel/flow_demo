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

  test "start_async_stream" do
    :timer.tc(fn ->
      FlowDemo.start_async_stream()
      :ok
    end)
    |> IO.inspect(label: "start_async_stream")
  end
end
