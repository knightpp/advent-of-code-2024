defmodule Aoc2024.Day9 do
  def part1() do
    File.read!("lib/day9/input.txt")
    |> part1()
  end

  def part1(input) do
    input
    |> parse_input()
    |> Stream.unfold(&unfold_blocks/1)
    |> Enum.to_list()
    |> defragment()
    |> checksum()
  end

  defp unfold_blocks([]), do: nil

  defp unfold_blocks([el | rest]) do
    case el do
      {:file, index, 1} -> {{:file, index}, rest}
      {:file, index, size} -> {{:file, index}, [{:file, index, size - 1} | rest]}
      {:free, 0} -> unfold_blocks(rest)
      {:free, 1} -> {:free, rest}
      {:free, size} -> {:free, [{:free, size - 1} | rest]}
    end
  end

  defp checksum(list) do
    list
    |> Stream.filter(&(&1 != :free))
    |> Stream.with_index()
    |> Stream.map(fn {{:file, id}, pos} -> id * pos end)
    |> Enum.sum()
  end

  defp defragment(list, ended? \\ false)
  defp defragment([], _), do: []

  defp defragment([x | rest], true) do
    [x | defragment(rest, true)]
  end

  defp defragment([x | rest], false) do
    case x do
      {:file, _} = file ->
        [file | defragment(rest, false)]

      :free ->
        {last, rest} = pop_last_file(rest)

        if last == nil do
          defragment(rest, true)
        else
          [last | defragment(rest, false)]
        end
    end
  end

  defp pop_last_file(list) do
    :lists.reverse(list)
    |> Enum.reduce({nil, []}, fn
      :free, {first_file, acc} -> {first_file, [:free | acc]}
      file, {nil, acc} -> {file, [:free | acc]}
      file, {first_file, acc} -> {first_file, [file | acc]}
    end)
  end

  defp parse_input(line) do
    line
    |> String.trim()
    |> String.to_charlist()
    |> Stream.with_index()
    |> Enum.reduce({:file, []}, fn
      {num_blocks, index}, {:file, acc} ->
        file_index = div(index, 2)
        {:free, [{:file, file_index, num_blocks - ?0} | acc]}

      {num_blocks, _}, {:free, acc} ->
        {:file, [{:free, num_blocks - ?0} | acc]}
    end)
    |> elem(1)
    |> then(fn list -> :lists.reverse(list) end)
  end
end
