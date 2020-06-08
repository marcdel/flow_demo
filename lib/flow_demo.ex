defmodule FlowDemo do
  alias __MODULE__.{Organization, Usage, Bills}

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
    |> Enum.flat_map(&Bills.generate(&1))
  end

  def start do
    Organization.billing_periods()
    |> Organization.by_region()
    |> Flow.from_enumerables()
    |> Flow.partition(stages: 6)
    |> Flow.map(&Usage.read_usage/1)
    |> Flow.map(&Usage.write_usage/1)
    |> Flow.map(&Usage.storage_usage/1)
    #    |> Flow.map(fn billing_period ->
    #      billing_period
    #      |> Usage.read_usage()
    #      |> Usage.write_usage()
    #      |> Usage.storage_usage()
    #    end)
    |> Flow.partition(stages: 50)
    |> Flow.flat_map(&Bills.generate(&1))
    |> Enum.to_list()
  end
end
