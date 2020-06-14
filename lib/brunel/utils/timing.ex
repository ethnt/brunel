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

  def datetime_in_seconds_of_day(datetime) do
    {hours, minutes, seconds} = datetime |> Calendar.DateTime.to_time() |> Calendar.Time.to_erl()

    hours * 3600 + minutes * 60 + seconds
  end

  def date_to_datetime(date) do
    str = Calendar.Date.to_s(date) <> "T04:00:00Z"

    with {:ok, datetime} <- Calendar.DateTime.Parse.rfc3339(str, "America/New_York") do
      datetime
    end
  end

  def date_interval(date1, date2) do
    from = date_to_datetime(date1)
    to = date_to_datetime(date2)

    %Calendar.DateTime.Interval{from: from, to: to}
  end

  def date_in_interval?(interval, date) do
    datetime = date_to_datetime(date)

    Calendar.DateTime.Interval.includes?(interval, datetime)
  end

  def seconds_to_time(time_in_seconds) do
    hours = div(time_in_seconds, 3600) |> Integer.to_string() |> String.pad_leading(2, "0")

    minutes =
      div(rem(time_in_seconds, 3600), 60) |> Integer.to_string() |> String.pad_leading(2, "0")

    seconds =
      div(String.to_integer(minutes), 60) |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{hours}:#{minutes}:#{seconds}"
  end

  def new_datetime(years, months, days, hours, minutes, seconds) do
    Calendar.DateTime.from_erl!({{years, months, days}, {hours, minutes, seconds}}, "UTC")
  end
end
