defmodule Brunel.GTFS.Agency do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.GTFS.Resource

  defstruct ~w(agency_id agency_name agency_url agency_timezone agency_lang agency_phone)a

  alias Brunel.Utils
  alias Brunel.GTFS.Agency

  @typedoc """
  Represents an agency in the dataset.
  """
  @type t :: %__MODULE__{
          agency_id: String.t(),
          agency_name: String.t(),
          agency_url: String.t(),
          agency_timezone: String.t(),
          agency_lang: String.t(),
          agency_phone: String.t()
        }

  @impl Brunel.GTFS.Resource
  @spec load(dataset :: Brunel.GTFS.Dataset.t()) :: Brunel.GTFS.Dataset.t()
  def load(%{source: source} = dataset) do
    agencies =
      with {:ok, file} = Utils.Zip.get("agency.txt", source) do
        file
        |> Utils.CSV.parse()
        |> Utils.recursive_struct(Agency)
      end

    %{dataset | agencies: agencies}
  end
end
