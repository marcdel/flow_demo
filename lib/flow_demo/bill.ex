defmodule FlowDemo.Bill do
  defstruct [:billing_period, :type, :start, :stop, :cost]

  def generate(billing_period) do
    Work.easy()

    FakeTelemetry.execute(
      "Generating bills for organization: #{billing_period.organization.id}, type: #{
        billing_period.type
      }, provider: #{billing_period.organization.provider}, region: #{
        billing_period.organization.region
      }"
    )

    %__MODULE__{
      billing_period: billing_period,
      type: billing_period.type,
      start: billing_period.start,
      stop: billing_period.stop,
      cost: calculate_cost(billing_period)
    }
  end

  defp calculate_cost(%{type: :free}), do: 0

  defp calculate_cost(billing_period) do
    %{reads: reads, writes: writes, storage: storage} = billing_period.usage
    (reads + writes + storage) * Enum.random(1..10)
  end
end
