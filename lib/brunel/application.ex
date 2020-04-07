defmodule Brunel.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Brunel.Repo, []}
    ]

    Mix.Task.run("ecto.migrate", ["-r", "Brunel.Repo"])

    opts = [strategy: :one_for_one, name: Brunel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
