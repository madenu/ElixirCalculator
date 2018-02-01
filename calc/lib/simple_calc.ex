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
    case los do
      [] -> {:none, 0.0, []}
      [first | rest] -> eval(first, rest)
      _ -> raise "Whatta Terrible Failure?!"
    end
  end

  def eval :opened, rest do
    try do
      {:closed, operand, rest} = eval(rest)
      eval(:constant, operand, rest)
    rescue
      e in RuntimeError -> "Invalid Input"
    end
  end

  # evalaute expression given the first part and the rest
  # String List<String> -> float
  def eval first, rest do
    {temp, parsed} = {first, Integer.parse(first)}
    case {temp, parsed} do
      {"(", :error} -> eval(:opened, rest)
      {first, {prev, rem}} -> eval(:constant, prev, rest)
      _ -> raise "Invalid Input"
    end
  end

  # prev is the integer just before this part of the expression
  # check for more input
  def eval :constant, prev, los do
    case los do
      [] -> {:none, prev, []}
      [first | rest] -> eval(prev, first, rest)
    end
  end

  # prev is the integer just before this part of the expression
  # evaluate the rest of the expression
  def eval prev, first, rest do
    case first do
      ")" -> {:closed, prev, rest}
      "+" ->
        {state, operand, rest} = eval(rest)
        {state, prev + operand, rest}
      "-" ->
        {state, operand, rest} = eval(rest)
        {state, prev - operand, rest}
      "*" ->
        {state, operand, rest} = eval(:multiply, rest)
        {state, prev * operand, rest}
      "/" ->
        {state, operand, rest} = eval(:divide, rest)
        {state, prev / operand, rest}
      _ -> raise "Invalid Input"
    end
  end
end
