defmodule SimpleCalcTest do
  use ExUnit.Case
  doctest SimpleCalc

  def split_filter str do
    str |> String.split("") |> Enum.filter(fn x -> (x != "") && (x != " ") end)
  end

  test "add/subtract no parens" do
    assert SimpleCalc.eval([]) == {:none, 0, []}
    assert SimpleCalc.eval(["1"]) == {:none, 1, []}
    assert SimpleCalc.eval(["-1"]) == {:none, -1, []}
    assert SimpleCalc.eval(split_filter("1+2")) == {:none, 3, []}
    assert SimpleCalc.eval(split_filter("1+2-2+1")) == {:none, 2, []}
    assert SimpleCalc.eval(split_filter("2 + 3 - 1 + 2 - 1 + 2")) == {:none, 7, []}
  end

  test "add/subtract with parens" do
  end

  test "multiply/divide no parens" do
  end

  test "multiply/divide with parens" do
  end

  test "four functions no parens" do
  end

  test "four functions with parens" do
  end

  # TODO test helper methods individually

end
