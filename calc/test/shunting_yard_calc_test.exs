defmodule ShuntingYardCalcTest do
  use ExUnit.Case
  doctest UglyCalc

  def split_filter(str) do
    str |> String.split("") |> Enum.filter(fn x -> x != "" && x != " " end)
  end
end
