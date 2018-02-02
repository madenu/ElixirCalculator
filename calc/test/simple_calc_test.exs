defmodule SimpleCalcTest do
  use ExUnit.Case
  doctest SimpleCalc

  def split_filter str do
    str |> String.split("") |> Enum.filter(fn x -> (x != "") && (x != " ") end)
  end

  test "examples from assignment" do
    assert SimpleCalc.eval(["2", "+", "3"]) == {:none, 5, []}
    assert SimpleCalc.eval(["5", "*", "1"]) == {:none, 5, []}
    assert SimpleCalc.eval(["20", "/", "4"]) == {:none, 5, []}
    assert SimpleCalc.eval(["24", "/", "6", "+", "(", "5", "-", "4", ")"]) == {:none, 5, []}
  end

  test "add/subtract no parens" do
    assert SimpleCalc.eval([]) == {:none, 0, []}
    assert SimpleCalc.eval(["1"]) == {:none, 1, []}
    assert SimpleCalc.eval(["-1"]) == {:none, -1, []}
    assert SimpleCalc.eval(split_filter("1+2")) == {:none, 3, []}
    assert SimpleCalc.eval(split_filter("1+2-2+1")) == {:none, 2, []}
    assert SimpleCalc.eval(split_filter("2 + 3 - 1 + 2 - 1 + 2")) == {:none, 7, []}
  end

  test "harder" do
    input_ls = ["(", "(", "(", "(", "8", ")", ")", ")", ")", "-", "(", "92", "/", "3", ")",
 "+", "4", "-", "(", "1", "/", "3", ")", "*", "2", "+", "1", "+"]
    input = "((((8)))) - (92 / 3) + 4 - (1/3) * 2 + 1 + 1"
    |> String.split("")
    |> Enum.filter(fn x -> (x != " ") && (x != "") && (x != "\n") end)
    assert SimpleCalc.reformat(input) == input_ls
    asssert SimpleCalc.eval(input_ls) == {:none, -24, []}
  end
end
