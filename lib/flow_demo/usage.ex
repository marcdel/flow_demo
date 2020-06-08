defmodule FlowDemo.Usage do
  alias __MODULE__

  defstruct [:type, :value]

  def write_usage(billing_period) do
    FakeTelemetry.execute(
      "Getting write usage for organization: #{billing_period.organization.id}, type: #{
        billing_period.type
      }"
    )

    Work.hard()
    %{billing_period | usage: billing_period.usage ++ [get_usage(:writes)]}
  end

  def read_usage(billing_period) do
    FakeTelemetry.execute(
      "Getting read usage for organization: #{billing_period.organization.id}, type: #{
        billing_period.type
      }"
    )

    Work.hard()
    %{billing_period | usage: billing_period.usage ++ [get_usage(:reads)]}
  end

  def storage_usage(billing_period) do
    FakeTelemetry.execute(
      "Getting storage usage for organization: #{billing_period.organization.id}, type: #{
        billing_period.type
      }"
    )

    Work.hard()
    %{billing_period | usage: billing_period.usage ++ [get_usage(:storage)]}
  end

  defp get_usage(type) do
    %Usage{type: type, value: Enum.random(1..100)}
  end
end
