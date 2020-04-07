defmodule BrunelUtilsZipSpec do
  @moduledoc false

  use ESpec

  alias Brunel.Utils.Zip

  describe "load/1" do
    it "returns a tuple with a handle when file exists" do
      file = Path.expand("../../../../fixtures/gtfs.zip", __ENV__.file)

      {:ok, pid} = Zip.load(file)

      expect pid |> to(be_pid())
    end

    it "returns an error when file does not exist" do
      result =
        "foo.zip"
        |> Zip.load()

      expect result |> to(match_pattern({:error, _}))
    end
  end

  describe "get/2" do
    let :zip_handle do
      file = Path.expand("../../../../fixtures/gtfs.zip", __ENV__.file)

      {:ok, pid} = Zip.load(file)

      pid
    end

    context "with file that exists" do
      it "returns an IO.Stream" do
        stream = Zip.get("agency.txt", zip_handle())

        expect stream |> to(be_struct(IO.Stream))
      end
    end

    context "with file that does not exist" do
      it "returns an error" do
        {:ok, stream} = Zip.get("foo.txt", zip_handle())

        expect stream |> to(match_pattern({:error, _}))
      end
    end
  end
end
