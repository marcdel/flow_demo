defmodule FlowDemo do
  alias __MODULE__.{Organization, Usage, Bill}

  @three_hours :timer.hours(3)

  def start_sync do
    Organization.billing_periods()
    |> Organization.by_provider()
    |> Enum.flat_map(& &1)
    |> Enum.map(fn billing_period ->
      billing_period
      |> Usage.read_usage()
      |> Usage.write_usage()
      |> Usage.storage_usage()
    end)
    |> Enum.flat_map(&Bill.generate(&1))
  end

  def start_async_stream do
    billing_periods = Organization.billing_periods()
    total_billing_periods = Enum.count(billing_periods)

    billing_periods
    |> Organization.by_region()
    |> Enum.flat_map(& &1)
    |> Task.async_stream(
      fn billing_period ->
        billing_period
        |> Usage.read_usage()
        |> Usage.write_usage()
        |> Usage.storage_usage()
        |> Bill.generate()
      end,
      timeout: 9_000,
      on_timeout: :kill_task
    )
    # |> Enum.reduce([], &handle_result/2)
    |> Enum.reduce([], fn
      {:ok, new_bill}, bills ->
        FakeTelemetry.execute(
          "[#{Enum.count(bills) + 1}/#{Enum.count(billing_periods)}] Got a new bill!"
        )

        bills ++ [new_bill]

      {:exit, :timeout}, bills ->
        # Keep on truckin...
        bills
    end)
  end

  defp handle_result({:ok, new_bill}, bills) do
    FakeTelemetry.execute("Got a new bill!")

    bills ++ [new_bill]
  end

  defp handle_result({:exit, :timeout}, bills) do
    # Keep on truckin...
    bills
  end

  def start do
    # multiple_orgs_across_region()
    multiple_orgs_grouped_by_region()
    # one_org_at_a_time_by_regions()
  end

  def multiple_orgs_across_regions do
    Organization.billing_periods()
    |> Organization.by_region()
    |> Flow.from_enumerables()
    |> Flow.partition(stages: 6)
    |> Flow.map(&Usage.read_usage/1)
    |> Flow.map(&Usage.write_usage/1)
    |> Flow.map(&Usage.storage_usage/1)
    |> Flow.flat_map(&Bill.generate(&1))
    |> Enum.to_list()
  end

  def multiple_orgs_grouped_by_region do
    Organization.billing_periods()
    |> Organization.by_region()
    |> Flow.from_enumerables()
    |> Flow.partition(stages: 6, key: {:key, :region})
    |> Flow.map(&Usage.read_usage/1)
    |> Flow.map(&Usage.write_usage/1)
    |> Flow.map(&Usage.storage_usage/1)
    |> Flow.flat_map(&Bill.generate(&1))
    |> Enum.to_list()
  end

  def one_org_at_a_time_by_region do
    Organization.billing_periods()
    |> Organization.by_region()
    |> Flow.from_enumerables()
    |> Flow.map(&Usage.read_usage/1)
    |> Flow.map(&Usage.write_usage/1)
    |> Flow.map(&Usage.storage_usage/1)
    |> Flow.flat_map(&Bill.generate(&1))
    |> Enum.to_list()
  end
end
