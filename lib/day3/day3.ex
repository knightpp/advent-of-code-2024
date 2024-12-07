defmodule Aoc2024.Day3 do
  def part1() do
    load_input()
    |> extract_instructions()
    |> execute_instructions()
  end

  def part1(input) do
    input
    |> extract_instructions()
    |> execute_instructions()
  end

  def part2(input \\ load_input()) do
    input
    |> extract_instructions2()
    |> execute_instructions2()
  end

  defp load_input() do
    File.read!("lib/day3/input.txt")
  end

  defp extract_instructions(input) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, input, capture: :all_but_first)
  end

  defp execute_instructions(instructions) do
    instructions
    |> Stream.map(fn [a, b] -> mul(a, b) end)
    |> Enum.sum()
  end

  defp mul(a, b) do
    {a, ""} = Integer.parse(a)
    {b, ""} = Integer.parse(b)
    a * b
  end

  defp extract_instructions2(input) do
    Regex.scan(~r/(mul)\((\d{1,3}),(\d{1,3})\)|don't\(\)|do\(\)/, input)
  end

  defp execute_instructions2(instructions) do
    instructions
    |> Enum.reduce({:do, 0}, fn
      instruction, {op, acc} ->
        case instruction do
          ["do()"] ->
            {:do, acc}

          ["don't()"] ->
            {:dont, acc}

          [_, "mul", a, b] ->
            case op do
              :do -> {:do, acc + mul(a, b)}
              :dont -> {:dont, acc}
            end
        end
    end)
    |> elem(1)
  end
end
