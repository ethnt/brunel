defmodule Brunel.Repo do
  @moduledoc """
  A repository for loaded datasets.
  """

  use Ecto.Repo,
    otp_app: :brunel,
    adapter: Sqlite.Ecto2
end
