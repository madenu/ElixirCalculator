defmodule ShuntingYardCalcTest do
  use ExUnit.Case
  alias ShuntingYardCalc, as: SYC
  doctest ShuntingYardCalc

  test "eval" do
    # los outq opstack
    assert SYC.eval([], [], []) == []
    assert SYC.eval(["0"], [], []) == ["0"]
    assert SYC.eval(["2", "+", "3"], [], []) == ["+", "3", "2"]
    assert SYC.eval(["(", "2", "+", "3", ")"], [], []) == ["+", "3", "2"]
    assert SYC.eval(["5", "*", "1"], [], []) == ["*", "1", "5"]
    assert SYC.eval(["(", "5", "*", "1", ")"], [], []) == ["*", "1", "5"]
    assert SYC.eval(["20", "/", "4"], [], []) == ["/", "4", "20"]
    assert SYC.eval(["(", "20", "/", "4", ")"], [], []) == ["/", "4", "20"]

    assert SYC.eval(["24", "/", "6", "+", "(", "5", "-", "4", ")"], [], []) ==
             ["+", "-", "4", "5", "/", "6", "24"]
  end

  def split_filter(str) do
    str |> String.split("") |> Enum.filter(fn x -> x != "" && x != " " end)
  end

  test "reformat" do
    input = "((((8)))) - (92 / 3) + 4 - (1/3) * 2 + 1 + 1"
    part1 = ["(", "(", "(", "(", "8", ")", ")", ")", ")", "-"]
    part2 = ["(", "92", "/", "3", ")", "+", "4", "-", "(", "1"]
    part3 = ["/", "3", ")", "*", "2", "+", "1", "+", "1"]
    expected = part1 ++ part2 ++ part3

    actual =
      with input_ls <- split_filter(input),
           act <- SYC.reformat(input_ls, "", []),
           do: act

    assert actual == expected
  end

  test "peek" do
    assert SYC.peek([1, 2, 3]) == 1
    assert SYC.peek([]) == nil
  end

  test "compare_to" do
    assert SYC.compare_to("+", "+") == 0
    assert SYC.compare_to("+", "-") == 0
    assert SYC.compare_to("/", "+") > 0
    assert SYC.compare_to("-", "*") < 0
  end

  test "op?" do
    assert SYC.op?("+") == true
    assert SYC.op?("-") == true
    assert SYC.op?("/") == true
    assert SYC.op?("*") == true
    assert SYC.op?(")") == false
    assert SYC.op?("(") == false
  end

  test "int?" do
    assert SYC.int?("0") == true
    assert SYC.int?("A") == false
    # truncates
    assert SYC.int?("2.0") == true
  end
end
