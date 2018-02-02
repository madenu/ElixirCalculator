defmodule SimpleCalc do
  # get input expression as a string from :stdio and evaluates it
  def main do
    result_tuple = IO.gets("> ")
    |> String.split("")
    |> Enum.filter(fn x -> (x != " ") && (x != "") && (x != "\n") end)
    |> reformat("", [])
    |> eval
    {:none, result, []} = result_tuple
    IO.inspect(result)
    main()
  end

  # evaluate expression given as a list of strings, each of length 1
  def eval los do
    if los != [] do
      [first | rest] = los
      case first do
        "-" -> eval(:subtract, 0, rest)
        _ -> eval(first, rest)
      end
    else
      {:none, 0.0, []}
    end
  end

  # reformats the given list of strings to primaries and operators
  def reformat los, temp, final do
    if los == [] do
      case temp do
        "" -> final
        _ -> final ++ [temp]
      end
    else
      [first | rest] = los
      cond do
        is_operator(first) && (temp == "") -> reformat(rest, "", final ++ [first])
        is_operator(first) -> reformat(rest, "", final ++ [temp, first])
        true -> reformat(rest, temp <> first, final)
      end
    end
  end

  # is given an operator or a space?
  defp is_operator given do
    case given do
      " " -> true
      "(" -> true
      ")" -> true
      "+" -> true
      "-" -> true
      "*" -> true
      "/" -> true
      _ -> false
    end
  end

  # evaluate the expression after an open paren
  defp eval :opened, rest do
    try do
      {:closed, operand, rest} = eval(rest)
      eval(:constant, operand, rest)
    rescue
      e in RuntimeError -> "Invalid Input"
    end
  end

  # check for more input
  # prev is the calculated value from the earlier part of this expression
  defp eval :constant, prev, los do
    case los do
      [] -> {:none, prev, []}
      [first | rest] -> eval(prev, first, rest)
      _ -> raise "Invalid Input"
    end
  end

  # add the next part of the expression prev
  defp eval :add, prev, los do
    if los == [] do
      raise "Invalid Input"
    end
    [first | rest] = los
    {prev, parsed} = {prev, Integer.parse(first)}
    case parsed do
      :error ->
        {state, operand, rest} = eval([first | rest])
        {state, prev + operand, rest}
        {val, rem} ->
          eval(:constant, prev + val, rest)
          _ -> raise "Invalid Input"
        end
      end

      # subtract the next part of the expression from prev
      defp eval :subtract, prev, los do
        if los == [] do
          raise "Invalid Input"
        end
        [first | rest] = los
        {prev, parsed} = {prev, Integer.parse(first)}
        case parsed do
          :error ->
            {state, operand, rest} = eval([first | rest])
            {state, prev - operand, rest}
            {val, rem} ->
              eval(:constant, prev - val, rest)
              _ -> raise "Invalid Input"
            end
          end

          # multiply prev by the next part of the expression
          defp eval :multiply, prev, los do
            if los == [] do
              raise "Invalid Input"
            end
            [first | rest] = los
            {prev, parsed} = {prev, Integer.parse(first)}
            case parsed do
              :error ->
                {state, operand, rest} = eval([first | rest])
                {state, prev * operand, rest}
                {val, rem} ->
                  eval(:constant, prev * val, rest)
                  _ -> raise "Invalid Input"
                end
              end

              # divide prev by the next part of the expression
              defp eval :divide, prev, los do
                if los == [] do
                  raise "Invalid Input"
                end
                [first | rest] = los
                {prev, parsed} = {prev, Integer.parse(first)}
                case parsed do
                  :error ->
                    {state, operand, rest} = eval([first | rest])
                    {state, div(prev, operand), rest}
                    {val, rem} ->
                      eval(:constant, div(prev, val), rest)
                      _ -> raise "Invalid Input"
                    end
                  end

                  # evalaute expression given the first part and the rest
                  defp eval first, rest do
                    {temp, parsed} = {first, Integer.parse(first)}
                    case {temp, parsed} do
                      {"(", :error} -> eval(:opened, rest)
                      {first, {prev, rem}} -> eval(:constant, prev, rest)
                      _ -> raise "Invalid Input"
                    end
                  end

                  # evaluate the rest of the expression
                  # prev is the integer just before this part of the expression
                  defp eval prev, first, rest do
                    case first do
                      ")" -> {:closed, prev, rest}
                      "+" -> eval(:add, prev, rest)
                      "-" -> eval(:subtract, prev, rest)
                      "*" -> eval(:multiply, prev, rest)
                      "/" -> eval(:divide, prev, rest)
                      _ -> raise "Invalid Input"
                    end
                  end
                end
