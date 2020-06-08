defmodule FlowDemo do
  alias __MODULE__.{Organization, Usage, Bill}

  @moduledoc """
  Documentation for `FlowDemo`.
  """

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
    |> Task.async_stream(fn(billing_period) ->
      billing_period
      |> Usage.read_usage()
      |> Usage.write_usage()
      |> Usage.storage_usage()
      |> Bill.generate()
    end, timeout: 9_000, on_timeout: :kill_task)
    |> Enum.reduce(%{bills: [], errors: []}, fn result, results ->
      handle_result(result, results)
    end)
  end

  defp handle_result({:ok, new_bills}, %{bills: bills} = results) do
    FakeTelemetry.execute("[Success] created #{Enum.count(new_bills)} bills: #{inspect(new_bills)}")

    %{results | bills: bills ++ new_bills}
  end

  defp handle_result({:error, new_errors}, %{errors: errors} = results) do
    FakeTelemetry.execute("[Error] couldn't create some bills: #{inspect(errors)}")

    %{results | errors: errors ++ new_errors}
  end

  def start do
#    multiple_orgs_across_region()
    multiple_orgs_grouped_by_region()
    #    one_org_at_a_time_by_regions()
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
