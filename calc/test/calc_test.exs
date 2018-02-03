defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "eval" do
    # los outq opstack
    assert Calc.eval([], [], []) == []
    assert Calc.eval(["0"], [], []) == ["0"]
    assert Calc.eval(["2", "+", "3"], [], []) == ["+", "3", "2"]
    assert Calc.eval(["(", "2", "+", "3", ")"], [], []) == ["+", "3", "2"]
    assert Calc.eval(["5", "*", "1"], [], []) == ["*", "1", "5"]
    assert Calc.eval(["(", "5", "*", "1", ")"], [], []) == ["*", "1", "5"]
    assert Calc.eval(["20", "/", "4"], [], []) == ["/", "4", "20"]
    assert Calc.eval(["(", "20", "/", "4", ")"], [], []) == ["/", "4", "20"]

    assert Calc.eval(["24", "/", "6", "+", "(", "5", "-", "4", ")"], [], []) ==
             ["+", "-", "4", "5", "/", "6", "24"]

    assert Calc.eval(["1", "+", "3", "*", "3", "+", "1"], [], []) ==
             ["+", "+", "1", "*", "3", "3", "1"]
  end

  test "eval_rpn" do
    assert ["+", "3", "2"] |> Enum.reverse() |> Calc.eval_rpn([]) == "5"
    assert ["*", "1", "5"] |> Enum.reverse() |> Calc.eval_rpn([]) == "5"
    assert ["/", "4", "20"] |> Enum.reverse() |> Calc.eval_rpn([]) == "5"

    assert ["+", "-", "4", "5", "/", "6", "24"]
           |> Enum.reverse()
           |> Calc.eval_rpn([]) == "5"

    assert ["+", "+", "1", "*", "3", "3", "1"]
           |> Enum.reverse()
           |> Calc.eval_rpn([]) == "11"
  end

  test "eval_calc" do
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
           act <- Calc.reformat(input_ls, "", []),
           do: act

    assert actual == expected
  end

  test "peek" do
    assert Calc.peek([1, 2, 3]) == 1
    assert Calc.peek([]) == nil
  end

  test "compare_to" do
    assert Calc.compare_to("+", "+") == 0
    assert Calc.compare_to("+", "-") == 0
    assert Calc.compare_to("/", "+") > 0
    assert Calc.compare_to("-", "*") < 0
  end

  test "op?" do
    assert Calc.op?("+") == true
    assert Calc.op?("-") == true
    assert Calc.op?("/") == true
    assert Calc.op?("*") == true
    assert Calc.op?(")") == false
    assert Calc.op?("(") == false
  end

  test "int?" do
    assert Calc.int?("0") == true
    assert Calc.int?("A") == false
    # truncates
    assert Calc.int?("2.0") == true
  end
end
