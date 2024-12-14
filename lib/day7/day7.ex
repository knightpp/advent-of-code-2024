defmodule Aoc2024.Day7 do
  @mul &Kernel.*/2
  @add &Kernel.+/2

  def part1() do
    part1(File.stream!("lib/day7/input.txt"))
  end

  def part1(input) do
    input
    |> parse_input()
    |> Stream.filter(fn {total, numbers} -> is_possible?(total, numbers) end)
    |> Stream.map(fn {total, _} -> total end)
    |> Enum.sum()
  end

  def part2() do
    part2(File.stream!("lib/day7/input.txt"))
  end

  def part2(input) do
    input
    |> parse_input()
    |> Stream.filter(fn {total, numbers} ->
      is_possible?(total, numbers, [@mul, @add, &number_or/2])
    end)
    |> Stream.map(fn {total, _} -> total end)
    |> Enum.sum()
  end

  defp number_or(a, b) do
    digits = Integer.digits(a) ++ Integer.digits(b)
    Integer.undigits(digits)
  end

  defp is_possible?(total, numbers, valid_ops \\ [@mul, @add])
       when is_list(numbers) and is_number(total) do
    perms = RC.perm_rep(valid_ops, length(numbers) - 1)

    Enum.reduce_while(perms, :ok, fn ops, _ ->
      if calc_numbers(numbers, ops) == total do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  defp calc_numbers([answer], []), do: answer

  defp calc_numbers([n1, n2 | numbers], [op | ops]) do
    calc_numbers([apply(op, [n1, n2]) | numbers], ops)
  end

  defp parse_input(input) when is_binary(input) do
    parse_input(String.splitter(input, "\n", trim: true))
  end

  defp parse_input(input) do
    input
    |> Stream.map(fn line ->
      [total, numbers] = String.split(line, ":")
      numbers = String.split(numbers) |> Enum.map(&parse_integer!/1)
      {parse_integer!(total), numbers}
    end)
  end

  defp parse_integer!(binary) do
    {num, ""} = Integer.parse(binary)
    num
  end
end

# TODO: understand this :(
# copied from https://rosettacode.org/wiki/Permutations_with_repetitions#Elixir
defmodule RC do
  def perm_rep(list), do: perm_rep(list, length(list))

  def perm_rep([], _), do: [[]]
  def perm_rep(_, 0), do: [[]]

  def perm_rep(list, i) do
    for x <- list, y <- perm_rep(list, i - 1), do: [x | y]
  end
end
