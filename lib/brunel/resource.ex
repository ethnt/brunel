defmodule Brunel.Resource do
  @moduledoc """
  Represents a resource in a static set of GTFS data.
  """

  @callback load(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
end
