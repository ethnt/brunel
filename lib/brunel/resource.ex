defmodule Brunel.Resource do
  @moduledoc """
  Represents a resource in a static set of GTFS data.
  """

  @callback build(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
end
