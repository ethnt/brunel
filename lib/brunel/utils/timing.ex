defmodule Brunel.Utils.Timing do
  @moduledoc """
  Utilities for dealing with time.
  """

  @time_zone "America/New_York"
  @days ~w[sunday monday tuesday wednesday thursday friday saturday]a

  @doc """
  Get the day of the week.
  """
  @spec day_of_week(String.t()) ::
          :sunday | :monday | :tuesday | :wednesday | :thursday | :friday | :saturday
  def day_of_week(date) do
    @days
    |> Enum.at(Calendar.Date.day_of_week_zb(date))
  end

  @doc """
  Today's date.
  """
  @spec today(String.t()) :: Date.t()
  def today(time_zone \\ @time_zone) do
    Calendar.Date.today!(time_zone)
  end

  @doc """
  The datetime right now.
  """
  @spec now(String.t()) :: DateTime.t()
  def now(time_zone \\ @time_zone) do
    Calendar.DateTime.now!(time_zone)
  end
end
