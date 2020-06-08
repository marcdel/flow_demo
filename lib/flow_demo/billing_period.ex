defmodule FlowDemo.BillingPeriod do
  defstruct [
    :organization,
    :provider,
    :region,
    :start,
    :stop,
    :type,
    usage: []
  ]
end
