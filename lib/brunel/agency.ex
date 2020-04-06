defmodule Brunel.Agency do
  defstruct ~w(agency_id agency_name)a

  alias Brunel
  alias Brunel.{Agency, Utils}

  @typedoc """
  Represents an agency in the dataset.
  """
  @type t :: %__MODULE__{
          agency_id: String.t(),
          agency_name: String.t()
        }

  def build(%{source: source} = dataset) do
    agencies =
      "agency.txt"
      |> Utils.csv_from_zip(source)
      |> Utils.recursive_struct(Agency)

    %{dataset | agencies: agencies}
  end
end
