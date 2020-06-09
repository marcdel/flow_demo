defmodule FlowDemo.Usage do
  defstruct [:writes, :reads, :storage]

  def write_usage(billing_period) do
    put_in(billing_period.usage.writes, get_usage(:writes, billing_period))
  end

  def read_usage(billing_period) do
    put_in(billing_period.usage.reads, get_usage(:reads, billing_period))
  end

  def storage_usage(billing_period) do
    put_in(billing_period.usage.storage, get_usage(:storage, billing_period))
  end

  defp get_usage(type, billing_period) do
    Work.hard()

    FakeTelemetry.execute(
      "Getting #{type} usage for organization: #{billing_period.organization.id}, type: #{
        billing_period.type
      }, provider: #{billing_period.organization.provider}, region: #{
        billing_period.organization.region
      }"
    )

    Enum.random(1..100)
  end
end
