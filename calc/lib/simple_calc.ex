
defmodule SimpleCalc do
  # get input expression as a string from :stdio and evaluates it
  def main do
    result_tuple = IO.gets("> ")
    |> String.split("")
    |> Enum.filter(fn x -> (x != " ") && (x != "") && (x != "\n") end)
    |> eval
    IO.inspect(result_tuple)
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

  # evaluate the expression after an open paren
  def eval :opened, rest do
    try do
      {:closed, operand, rest} = eval(rest)
      eval(:constant, operand, rest)
    rescue
      e in RuntimeError -> "Invalid Input"
    end
  end

  # check for more input
  # prev is the calculated value from the earlier part of this expression
  def eval :constant, prev, los do
    case los do
      [] -> {:none, prev, []}
      [first | rest] -> eval(prev, first, rest)
      _ -> raise "Invalid Input"
    end
  end

  # add the next part of the expression prev
  def eval :add, prev, los do
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
  def eval :subtract, prev, los do
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
  def eval :multiply, prev, los do
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
  def eval :divide, prev, los do
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
  def eval first, rest do
    {temp, parsed} = {first, Integer.parse(first)}
    case {temp, parsed} do
      {"(", :error} -> eval(:opened, rest)
      {first, {prev, rem}} -> eval(:constant, prev, rest)
      _ -> raise "Invalid Input"
    end
  end

  # evaluate the rest of the expression
  # prev is the integer just before this part of the expression
  def eval prev, first, rest do
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
