defmodule Aoc2024.Day12 do
  def part1() do
    File.read!("lib/day12/input.txt")
    |> part1()
  end

  def part1(input) do
    IO.puts("DOES NOT WORK")

    input
    |> parse_input()
    |> divide_into_regions()
  end

  defp divide_into_regions(parsed) do
    parsed
    |> Stream.map(fn {k, v} -> {k, reachable(v)} end)
    |> Stream.map(fn {k, v} -> {k, process_reachable(v)} end)
    |> Stream.map(fn {_k, v} -> v |> Stream.map(&calc/1) |> Enum.sum() end)
    |> Enum.sum()
  end

  defp calc(%MapSet{} = set) do
    perimeter = Aoc2024.Perimeter.calculate_with_internals(set)
    area = MapSet.size(set)
    perimeter * area
  end

  defp process_reachable(map, paths \\ [])
  defp process_reachable(map, paths) when map_size(map) == 0, do: paths

  defp process_reachable(%{} = map, paths) do
    [{point, _}] = map |> Enum.take(1)
    {map, path} = follow([point], map)
    process_reachable(map, [path | paths])
  end

  defp follow(points, map, acc \\ MapSet.new())
  defp follow([], map, acc), do: {map, acc}

  defp follow([point | rest], %{} = map, acc) do
    reaches = Map.get(map, point, [])
    {_, map} = Map.pop(map, point, :ok)
    follow(reaches ++ rest, map, MapSet.put(acc, point))
  end

  defp reachable(%MapSet{} = set) do
    set
    |> Stream.map(fn {x, y} ->
      reaches =
        [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
        |> Enum.filter(&MapSet.member?(set, &1))

      {{x, y}, reaches}
    end)
    |> Enum.into(%{})
  end

  defp parse_input(input) when is_binary(input) do
    input
    |> String.splitter("\n", trim: true)
    |> parse_input()
  end

  defp parse_input(input) do
    input
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.to_charlist()
      |> Stream.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.update(acc, char, MapSet.new([{x, y}]), fn old -> MapSet.put(old, {x, y}) end)
      end)
    end)
  end
end
