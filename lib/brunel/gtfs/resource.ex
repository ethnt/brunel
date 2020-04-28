defmodule Brunel.GTFS.Resource do
  @moduledoc """
  Represents a resource in a static set of GTFS data.
  """

  @callback load(dataset :: Brunel.GTFS.Dataset.t()) :: Brunel.GTFS.Dataset.t()
end
