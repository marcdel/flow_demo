defmodule FlowDemo.BillingPeriod do
  alias FlowDemo.Usage

  defstruct [
    :organization,
    :provider,
    :region,
    :start,
    :stop,
    :type,
    usage: %Usage{}
  ]
end
