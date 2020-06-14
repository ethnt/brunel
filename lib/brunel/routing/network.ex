defmodule Brunel.Routing.Network do
  @moduledoc """
  Generate a routing network from GTFS data.
  """

  @dwell_limit 3600

  @doc """
  Generate a graph for direct transfers.
  """
  @spec direct_transfers(Brunel.GTFS.Dataset.t()) :: Graph.t()
  def direct_transfers(%{stop_times: stop_times}) do
    graph = Graph.new()

    edges =
      stop_times
      |> Enum.sort_by(&Map.get(&1, :arrival_time))
      |> Enum.group_by(&Map.get(&1, :stop_id))
      |> Map.values()
      |> Enum.flat_map(fn stop_arrivals ->
        Enum.map(stop_arrivals, fn arrival ->
          connections_after_arrival(arrival, stop_arrivals)
          |> pair_and_map(arrival, fn stop_time -> stop_time.trip_id end)
        end)
      end)
      |> List.flatten()

    graph |> Graph.add_edges(edges)
  end

  @doc """
  Find all of the connections than can be taken after the arrival of the given stop time.
  """
  @spec connections_after_arrival(Brunel.GTFS.StopTime.t(), list(Brunel.GTFS.StopTime.t())) ::
          list(Brunel.GTFS.StopTime.t())
  def connections_after_arrival(stop_time, arrivals) do
    arrivals
    |> Enum.filter(fn connection ->
      connection.arrival_time > stop_time.arrival_time &&
        connection.departure_time < stop_time.arrival_time + @dwell_limit
    end)
  end

  def pair_and_map(list, pair, fun) do
    list
    |> Enum.map(fn elem ->
      {fun.(pair), fun.(elem)}
    end)
  end

  # Group by stop
  # For each stop
  #   For each stop time
  #     Get connections after stop time but before dwell limit
  #     For each connection
  #       Make graph edge
  # def direct_transfers(%{stop_times: stop_times}) do
  #   stop_times
  #   |> Enum.sort_by(&Map.get(&1, :arrival_time))
  #   |> Enum.group_by(&Map.get(&1, :stop_id))
  #   |> Enum.map_reduce(Graph.new, fn {{_, arrivals}, graph} ->
  #     Enum.each(arrivals, fn arrival ->
  #       arrivals
  #       |> Enum.filter(fn possible_connection ->
  #         possible_connection.arrival_time > arrival.arrival_time && possible_connection.departure_time < arrival.arrival_time + @dwell_limit
  #       end)
  #       |> Enum.each(fn connection ->
  #         graph |> Graph.add_edge(Graph.Edge.new(arrival.trip_id, connection.trip_id))
  #       end)
  #     end)
  #   end)
  # end
end
