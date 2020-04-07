defmodule BrunelUtilsSpec do
  @moduledoc false

  use ESpec

  describe "recursive_struct/2" do
    defmodule Foo do
      @moduledoc false

      defstruct ~w(foo bar)a
    end

    it "recursively turns each map into a struct" do
      result = Brunel.Utils.recursive_struct([%{foo: "bar"}, %{foo: "bar"}], BrunelUtilsSpec.Foo)

      expect(result) |> to(have_all(fn e -> e |> to(be_struct BrunelUtilsSpec.Foo) end))
    end
  end
end
