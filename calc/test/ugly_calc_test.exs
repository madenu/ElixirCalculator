defmodule UglyCalcTest do
  use ExUnit.Case
  doctest UglyCalc

  def split_filter(str) do
    str |> String.split("") |> Enum.filter(fn x -> x != "" && x != " " end)
  end

  test "examples from assignment" do
    assert UglyCalc.eval(["2", "+", "3"]) == {:none, 5, []}
    assert UglyCalc.eval(["5", "*", "1"]) == {:none, 5, []}
    assert UglyCalc.eval(["20", "/", "4"]) == {:none, 5, []}
    assert UglyCalc.eval(["24", "/", "6", "+", "(", "5", "-", "4", ")"]) == {:none, 5, []}
  end

  test "add/subtract no parens" do
    assert UglyCalc.eval([]) == {:none, 0, []}
    assert UglyCalc.eval(["1"]) == {:none, 1, []}
    assert UglyCalc.eval(["-1"]) == {:none, -1, []}
    assert UglyCalc.eval(split_filter("1+2")) == {:none, 3, []}
    assert UglyCalc.eval(split_filter("1+2-2+1")) == {:none, 2, []}
    assert UglyCalc.eval(split_filter("2 + 3 - 1 + 2 - 1 + 2")) == {:none, 7, []}
  end

  test "harder" do
    input = "((((8)))) - (92 / 3) + 4 - (1/3) * 2 + 1 + 1"

    part1 = ["(", "(", "(", "(", "8", ")", ")", ")", ")", "-"]
    part2 = ["(", "92", "/", "3", ")", "+", "4", "-", "(", "1"]
    part3 = ["/", "3", ")", "*", "2", "+", "1", "+", "1"]
    expected = part1 ++ part2 ++ part3

    actual =
      with input_ls <- split_filter(input),
           act <- UglyCalc.reformat(input_ls, "", []),
           do: act

    assert actual == expected
    assert UglyCalc.eval(actual) == {:none, -24, []}
  end
end
