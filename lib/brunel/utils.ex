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

  def recursive_changeset(list, module) do
    list
    |> Enum.map(fn x -> module.changeset(struct(module), x) end)
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

  @doc """
  Cast a value in a list of maps into the given type.

      iex> Utils.cast_values([%{foo: "1"}, %{foo: "2"}], :foo, :integer)
      [%{foo: 1}, %{foo: 2}]
  """
  @spec cast_values([map], atom | bitstring, :integer | :float) :: [map]
  def cast_values(maps, key, type) do
    Enum.map(maps, fn m -> cast_value(m, key, type) end)
  end
end
