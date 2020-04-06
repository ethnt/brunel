defmodule Brunel.Resource do
  @callback build(Brunel.Dataset.t()) :: Brunel.Dataset.t()
end
