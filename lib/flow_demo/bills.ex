defmodule FlowDemo.Bills do
  def generate(billing_period) do
    Enum.map(billing_period.usage, fn usage ->
      duration = Work.easy()

      FakeTelemetry.execute(
        "Generating bills for organization: #{billing_period.organization.id}, usage type: #{
          billing_period.type
        }, provider: #{billing_period.organization.provider}, region: #{
          billing_period.organization.region
        }, duration: #{duration}"
      )

      %{
        organization_id: billing_period.organization.id,
        start: billing_period.start,
        stop: billing_period.stop,
        cost: calculate_cost(usage)
      }
    end)
  end

  defp calculate_cost(%{type: :free}), do: 0

  defp calculate_cost(%{value: value}) do
    value * Enum.random(1..10)
  end
end
