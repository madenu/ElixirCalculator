defmodule ShuntingYardCalc do
  # get input expression as a string from :stdio and evaluates it
  def main do
    result_tuple =
      IO.gets("> ")
      |> String.split("")
      |> Enum.filter(fn x -> x != " " && x != "" && x != "\n" end)
      |> reformat("", [])
      |> eval("", [])

    {:none, result, []} = result_tuple
    IO.inspect(result)
    main()
  end

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
        op?(first) || first == ")" || first == "(" || (first == " " && temp == "") ->
          reformat(rest, "", final ++ [first])

        op?(first) || first == ")" || first == "(" || first == " " ->
          reformat(rest, "", final ++ [temp, first])

        true ->
          reformat(rest, temp <> first, final)
      end
    end

    {:none, 0, []}
  end

  # evaluate expression given as a list of exression tokens
  def eval(los, outq, opstack) do
    if los == [] do
      # outq |> eval
    else
    end
  end

  # is this token an integer?
  def int?(token) do
    case Integer.parse(token) do
      {res, _} -> true
      _ -> false
    end
  end

  # is this token an operator?

  def op?(token) do
    case token do
      "+" -> true
      "-" -> true
      "*" -> true
      "/" -> true
      _ -> false
    end
  end

  # peek at the top of the stack
  def peek(stack) do
    [res | _] = stack
    res
  end
end
