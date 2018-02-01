defmodule SimpleCalcTest do
  use ExUnit.Case
  doctest SimpleCalc

  def split_filter str do
    str |> String.split("") |> Enum.filter(fn x -> (x != "") && (x != " ") end)
  end

  test "add/subtract no parens" do
    assert SimpleCalc.eval([]) == {:none, 0.0, []}
    assert SimpleCalc.eval(["1"]) == {:none, 1.0, []}
    assert SimpleCalc.eval(split_filter("1+2")) == {:none, 3.0, []}
    assert SimpleCalc.eval(split_filter("1+2-2+1")) == {:none, 2.0, []}
    assert SimpleCalc.eval(split_filter("2 + 3 - 1 + 2 - 1 + 2")) = {:none, 7, []}
  end
end
