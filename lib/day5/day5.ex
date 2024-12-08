defmodule Aoc2024.Day5 do
  def part1(input \\ load_input()) do
    {rules, pages} = parse_input(input)

    pages
    |> Stream.filter(&is_line_correct(&1, rules))
    |> Stream.map(fn line ->
      index = div(Enum.count(line), 2)
      Enum.at(line, index)
    end)
    |> Enum.sum()
  end

  defp load_input() do
    File.read!("lib/day5/input.txt")
  end

  defp is_line_correct(line, rules) do
    char_to_index = line |> Stream.with_index() |> Enum.into(%{})

    line
    |> Stream.with_index()
    |> Enum.all?(fn {char, index} ->
      with {:ok, before_list} <- Map.fetch(rules, char) do
        Enum.all?(before_list, fn before ->
          with {:ok, target_index} <- Map.fetch(char_to_index, before) do
            is_before = index < target_index
            is_before
          else
            :error -> true
            _ -> true
          end
        end)
      else
        :error -> true
        _ -> true
      end
    end)
  end

  defp parse_input(input) do
    {_, rules, pages} =
      input
      |> String.splitter("\n")
      |> Enum.reduce({:rules, [], []}, fn
        "", {_, rules, pages} -> {:pages, rules, pages}
        rule, {:rules, rules, pages} -> {:rules, [parse_rule(rule) | rules], pages}
        line, {:pages, rules, pages} -> {:pages, rules, [parse_page_seq(line) | pages]}
      end)

    rules =
      Enum.reduce(rules, %{}, fn {a, b}, acc ->
        Map.update(acc, a, [b], fn list -> [b | list] end)
      end)

    {rules, pages}
  end

  defp parse_rule(rule) do
    [a, b] = String.split(rule, "|")
    {parse_int!(a), parse_int!(b)}
  end

  defp parse_page_seq(line) do
    line |> String.splitter(",") |> Enum.map(&parse_int!/1)
  end

  defp parse_int!(str) do
    {int, ""} = Integer.parse(str)
    int
  end
end
