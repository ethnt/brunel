defmodule Brunel.Utils do
  @moduledoc """
  Utilities for transforming data.
  """

  @doc """
  Recursively build a struct for each element in a list.
  """
  @spec recursive_struct([%{required(atom) => any}], term) :: [struct]
  def recursive_struct(list, struct) do
    list
    |> Enum.map(fn x -> struct(struct, x) end)
  end

  @doc """
  Cast a value in a map into the given type.

      iex> Utils.cast_value(%{foo: "1"}, :foo, :integer)
      %{foo: 1}
  """
  @spec cast_value(map, atom | bitstring, :integer | :float) :: map
  def cast_value(map, key, type) do
    value = Map.get(map, key)

    cast_value(map, key, value, type)
  end

  @spec cast_value(map, atom | bitstring, integer | bitstring, :integer) :: map
  defp cast_value(map, key, value, :integer) when is_bitstring(value) do
    casted_value = String.to_integer(value)

    %{map | key => casted_value}
  end

  defp cast_value(map, _key, value, :integer) when is_integer(value), do: map

  @spec cast_value(map, atom, bitstring, :float) :: map
  defp cast_value(map, key, value, :float) when is_bitstring(value) do
    casted_value = String.to_float(value)

    %{map | key => casted_value}
  end

  defp cast_value(map, _key, value, :float) when is_float(value), do: map

  @spec cast_value(map, atom, bitstring, :datetime) :: Date.t()
  defp cast_value(map, key, value, :datetime) when is_bitstring(value) do
    with {:ok, casted_value} <- Calendar.Date.Parse.iso8601(value) do
      %{map | key => casted_value}
    end
  end

  @spec cast_value(map, atom, bitstring, :time) :: Time.t()
  defp cast_value(map, key, value, :time) when is_bitstring(value) do
    case Calendar.Time.Parse.iso8601(value) do
      {:ok, casted_value} -> %{map | key => casted_value}
      {:error, :invalid_time} -> cast_value(map, key, fix_over_time(value), :time)
      _ -> map
    end
  end

  @doc """
  Cast a value in a list of maps into the given type.

      iex> Utils.cast_values([%{foo: "1"}, %{foo: "2"}], :foo, :integer)
      [%{foo: 1}, %{foo: 2}]
  """
  @spec cast_values([map], atom | bitstring, :integer | :float | :datetime | :time) :: [map]
  def cast_values(maps, key, type) do
    Enum.map(maps, fn m -> cast_value(m, key, type) end)
  end

  defp fix_over_time(time) do
    [hours, minutes, seconds] =
      time
      |> String.split(":")
      |> Enum.map(&String.to_integer/1)

    [hours - 24, minutes, seconds]
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(fn num -> String.pad_leading(num, 2, "0") end)
    |> Enum.join(":")
  end
end
