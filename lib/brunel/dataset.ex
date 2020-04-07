defmodule Brunel.Dataset do
  @moduledoc """
  A set of GTFS data.
  """

  # alias Brunel.{Agency, Stop, StopTime, Trip, Utils}

  use Ecto.Schema

  schema "datasets" do
  end

  # @spec load(String.t()) :: {:error, any} | {:ok, Brunel.Dataset.t()}
  # def load(filename) do
  #   with {:ok, handle} <- Utils.Zip.load(filename) do
  #     dataset =
  #       %Brunel.Dataset{source: handle}
  #       |> Agency.load()
  #       |> Stop.load()
  #       |> StopTime.load()
  #       |> Trip.load()

  #     {:ok, dataset}
  #   end
  # end
end
