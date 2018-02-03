# TODO should I have different function names or should I match on atoms?
# TODO edit .formatter.exs to not use so much vertical whitespace

precedence = %{"+" => 0, "-" => 0, "*" => 1, "/" => 1}

defmodule ShuntingYardCalc do
  # get input expression as a string from :stdio and evaluates it
  # def main do
  #   result_tuple =
  #     IO.gets("> ")
  #     |> String.split("")
  #     |> Enum.filter(fn x -> x != " " && x != "" && x != "\n" end)
  #     |> reformat("", [])
  #
  #   main()
  # end

  # reformats the given list of strings to expression tokens
  def reformat(los, temp, final) do
    if los == [] do
      case temp do
        "" -> final
        _ -> final ++ [temp]
      end
    else
      [first | rest] = los

      cond do
        (op?(first) || first == ")" || first == "(" || first == " ") && temp == "" ->
          reformat(rest, "", final ++ [first])

        op?(first) || first == ")" || first == "(" || first == " " ->
          reformat(rest, "", final ++ [temp, first])

        true ->
          reformat(rest, temp <> first, final)
      end
    end
  end

  # evaluate expression given as a list of exression tokens
  def eval(los, outq, opstack) do
    if los == [] do
      eval_fin(los, outq, opstack)
    else
      [token | rest] = los

      cond do
        int?(token) ->
          # push to outq
          eval(rest, [token | outq], opstack)

        op?(token) ->
          # pop greater precedence ops from opstack to outq
          eval_op([token | rest], outq, opstack)

        token == "(" ->
          # push left paren onto stack
          eval(rest, outq, [token | opstack])

        token == ")" ->
          # pop operators between parens from opstack
          eval_paren(rest, outq, opstack)
      end
    end
  end

  # returns a Map of the current operators
  defp operators do
    %{"+" => 0, "-" => 0, "*" => 1, "/" => 1}
  end

  # recursive helper for when token is an operator
  defp eval_op(rest, outq, opstack) do
    # rest should never be [] in this function
    [op | rest] = rest
    top = peek(opstack)

    cond do
      # handle empty opstack or left paren
      top == nil || top == "(" ->
        eval(rest, outq, [op | opstack])

      # pop higher precedence operators
      compare_to(op, top) < 0 ->
        [top | opstack] = opstack
        eval_op([op | rest], [top | outq], opstack)
    end
  end

  # recursive helper for when token is a left paren
  defp eval_paren(rest, outq, opstack) do
    [token | opstack] = opstack

    if token != "(" do
      eval_paren(rest, [token | outq], opstack)
    else
      eval(rest, outq, opstack)
    end
  end

  # recursive helper for when there are no more tokens
  # rest input unused, but keep for now
  defp eval_fin(rest, outq, opstack) do
    if opstack == [] do
      outq
    else
      [op | opstack] = opstack

      case op do
        "(" -> raise "Mismatched Parentheses"
        ")" -> raise "Mismatched Parentheses"
        _ -> eval_fin(rest, [op | outq], opstack)
      end
    end
  end

  # is this token an integer?
  # (truncates float tokens e.g. 2.3 -> 2)
  def int?(token) do
    parsed = Integer.parse(token)

    case parsed do
      {_, _} -> true
      _ -> false
    end
  end

  # is this token an operator?
  def op?(token) do
    operators() |> Map.has_key?(token)
  end

  # return less than, equal to, greater than zero
  def compare_to(op1, op2) do
    ops = operators()
    ops[op1] - ops[op2]
  end

  # returns the item at the front of the list
  def peek(stack) do
    case stack do
      [] -> nil
      [top | _] -> top
      _ -> raise "Peek Called on Non-List"
    end
  end
end
