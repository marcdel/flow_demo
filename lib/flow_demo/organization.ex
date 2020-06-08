defmodule FlowDemo.Organization do
  alias __MODULE__
  alias FlowDemo.BillingPeriod

  defstruct [:id, :provider, :region]

  def billable do
    FakeTelemetry.execute("Getting billable organizations")
    Work.medium()

    [
      %Organization{id: 1, provider: "AWS", region: "us-west-1"},
      %Organization{id: 2, provider: "AWS", region: "us-west-2"},
      %Organization{id: 3, provider: "AWS", region: "us-east-1"},
      %Organization{id: 4, provider: "GCP", region: "us-west-1"},
      %Organization{id: 5, provider: "GCP", region: "us-west-2"},
      %Organization{id: 7, provider: "Azure", region: "us-west-1"}
    ]
  end

  def by_provider(billing_periods) do
    FakeTelemetry.execute("Grouping by providers")
    Work.easy()

    Enum.group_by(billing_periods, & &1.organization.provider)
    |> Map.values()
  end

  def billing_periods do
    FakeTelemetry.execute("Getting billing periods")

    Work.medium()
    organizations = billable()

    Enum.flat_map(organizations, fn organization ->
      get_billing_periods(organization)
    end)
  end

  defp get_billing_periods(organization) do
    [
      %BillingPeriod{
        organization: organization,
        start: DateTime.add(DateTime.utc_now(), -60, :second),
        stop: DateTime.utc_now(),
        type: :pay
      },
      %BillingPeriod{
        organization: organization,
        start: DateTime.add(DateTime.utc_now(), -120, :second),
        stop: DateTime.add(DateTime.utc_now(), -60, :second),
        type: :free
      }
    ]
  end
end
