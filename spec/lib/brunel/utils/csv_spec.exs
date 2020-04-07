defmodule BrunelUtilsCSVSpec do
  @moduledoc false

  use ESpec

  alias Brunel.Utils.CSV

  describe "parse/1" do
    let :csv do
      contents = """
      col1,col2,col3
      foo,bar,foobar
      biz,baz,bizbaz
      """

      {:ok, file} = StringIO.open(contents)

      IO.stream(file, :line)
    end

    let :result do
      CSV.parse(csv())
    end

    it "returns correct number of rows" do
      expect(Enum.count(result())) |> to(eq 2)
    end

    it "returns a list of maps" do
      expect(Enum.at(result(), 0)) |> to(eq %{col1: "foo", col2: "bar", col3: "foobar"})
    end
  end
end
