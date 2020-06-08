defmodule FlowDemo.BillingPeriod do
  defstruct [
    :organization,
    :start,
    :stop,
    :type,
    usage: []
  ]
end
