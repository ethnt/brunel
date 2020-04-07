defmodule Brunel.Agency do
  @moduledoc """
  Represents agency data.
  """

  @behaviour Brunel.Resource

  defstruct ~w(agency_id agency_name agency_url agency_timezone agency_lang agency_phone)a

  alias Brunel.{Agency, Utils}

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

  @impl Brunel.Resource
  @spec build(dataset :: Brunel.Dataset.t()) :: Brunel.Dataset.t()
  def build(%{source: source} = dataset) do
    agencies =
      "agency.txt"
      |> Utils.Zip.get(source)
      |> Utils.CSV.parse()
      |> Utils.recursive_struct(Agency)

    %{dataset | agencies: agencies}
  end
end
