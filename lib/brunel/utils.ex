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
end
