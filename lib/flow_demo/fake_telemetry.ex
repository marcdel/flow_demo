defmodule FakeTelemetry do
  def execute(value, options \\ []) do
    IO.inspect(value, options)
  end
end
