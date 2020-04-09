defmodule Brunel.Repo do
  @moduledoc """
  A repository for loaded datasets.
  """

  use Ecto.Repo,
    otp_app: :brunel,
    adapter: Ecto.Adapters.Postgres
end
