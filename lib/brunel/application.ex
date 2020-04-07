defmodule Brunel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Brunel.Worker.start_link(arg)
      # {Brunel.Worker, arg}
      {Brunel.Repo, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Brunel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
