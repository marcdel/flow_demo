defmodule FlowDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    true = OpenTelemetry.register_application_tracer(:flow_demo)

    children = [
      # Starts a worker by calling: FlowDemo.Worker.start_link(arg)
      # {FlowDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlowDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
