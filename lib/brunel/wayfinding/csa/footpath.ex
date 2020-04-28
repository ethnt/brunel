defmodule Brunel.Wayfinding.CSA.Footpath do
  @moduledoc """
  A triple consisting of a departure stop, the arriving stop, and the duration that represents a footpath. "These
  footpaths can be viewed as weighted, directed footpath graph GF = (S,F), where the stops are the nodes, the footpaths,
  the arcs, and the duration the weights. We define the transfer relation as follows: a@τa → b@τb holds, if and only if
  there is a path from a to b whose length is at most τb −τa."

  This is transitive. If a traveler at point A can go to point B, and then point B to point C, they must be able to go
  from point A to C.

  A transfer within a single station is called a "footpath loop", where the departure stop and the arriving stop are the
  same.
  """
end
