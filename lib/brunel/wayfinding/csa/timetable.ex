defmodule Brunel.Wayfinding.CSA.Timetable do
  @moduledoc """
  A quadruple that represents a timetable for one day.
  """

  defstruct ~w(stops connections trips footpaths)a

  @type t :: %__MODULE__{
          stops: list(),
          connections: list(),
          trips: list(),
          footpaths: list(),
        }
end
