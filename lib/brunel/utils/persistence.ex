defmodule Brunel.Utils.Persistence do
  @moduledoc """
  Some helpers for dealing with Memento.
  """

  alias Brunel.Utils.Persistence

  @tables [
    Brunel.Agency,
    Brunel.Route,
    Brunel.Trip
  ]

  @spec prepare :: :ok
  def prepare do
    @tables
    |> Enum.each(fn table -> Memento.Table.create!(table) end)
  end

  @spec all(table :: atom) :: [struct]
  def all(table) do
    Memento.transaction! fn ->
      Memento.Query.all(table)
    end
  end

  @spec count(table :: atom) :: non_neg_integer()
  def count(table) do
    Memento.Table.info(table)
    |> Keyword.get(:size)
  end

  def find_by(table, attribute, id) do
    Persistence.query(table, {:==, attribute, id}, limit: 1)
    |> Enum.at(0)
  end

  def query(table, guards, opts \\ []) do
    Memento.transaction! fn ->
      Memento.Query.select(table, guards, opts)
    end
  end

  @spec bulk_write(records :: [struct]) :: [struct]
  def bulk_write(records) do
    Memento.transaction! fn ->
      records
      |> Enum.reduce([], fn(record, acc) -> [Memento.Query.write(record) | acc] end)
    end
  end
end
