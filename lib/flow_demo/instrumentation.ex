defmodule Instrumentation do
  require OpenTelemetry.Span
  require OpenTelemetry.Tracer

  defmacro trace(name, do: block) do
    quote do
      require OpenTelemetry.Tracer

      OpenTelemetry.Tracer.with_span unquote(name) do
        {duration, result} =
          :timer.tc(fn ->
            unquote(block)
          end)

        result
      end
    end
  end

  def add_metadata(metadata \\ %{}) do
    Enum.each(metadata, fn {k, v} ->
      OpenTelemetry.Span.set_attribute(k, v)
    end)
  end
end
