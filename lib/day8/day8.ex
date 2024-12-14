defmodule Aoc2024.Day8 do
  def part1() do
    part1(File.stream!("lib/day8/input.txt", trim: true))
  end

  def part1(input) do
    parse_input(input)
    |> calculate_unique_antinodes(&points_to_antinodes/3)
  end

  def part2() do
    part2(File.stream!("lib/day8/input.txt", trim: true))
  end

  def part2(input) do
    parse_input(input)
    |> calculate_unique_antinodes(&points_to_antinodes_part2/3)
  end

  defp parse_input(input) when is_binary(input) do
    parse_input(String.splitter(input, "\n", trim: true))
  end

  defp parse_input(stream) do
    Enum.reduce(stream, {{:init, 0}, %{}}, fn
      line, {{:init, y}, map} ->
        {{String.length(String.trim(line)), y + 1}, parse_line(line, y, map)}

      line, {{x, y}, map} ->
        {{x, y + 1}, parse_line(line, y, map)}
    end)
  end

  defp parse_line(line, y, into_map) do
    line
    |> String.to_charlist()
    |> Stream.with_index()
    |> Stream.filter(fn {char, _} -> char != ?. end)
    |> Stream.map(fn {char, x} -> {char, {x, y}} end)
    |> Enum.reduce(into_map, fn {char, point}, acc ->
      Map.update(acc, char, [point], fn list -> [point | list] end)
    end)
  end

  defp calculate_unique_antinodes({max, map}, converter) do
    map
    |> Stream.map(fn {_freq, points} -> process_points(points, max, converter) end)
    |> Enum.reduce(%{}, fn map, acc ->
      Map.merge(acc, map)
    end)
    |> map_size()
  end

  defp process_points(points, max, converter) do
    points
    |> all_point_pairs()
    |> Stream.flat_map(&Function.identity/1)
    |> Stream.map(fn {p1, p2} -> converter.(p1, p2, max) end)
    |> Stream.flat_map(&Function.identity/1)
    |> Stream.filter(fn p -> not is_outside?(p, max) end)
    |> Stream.with_index()
    |> Enum.into(%{})
  end

  defp is_outside?(point, max)

  defp is_outside?({x, y}, {max_x, max_y}) do
    x > max_x - 1 or y > max_y - 1 or x < 0 or y < 0
  end

  # TODO: manhattan distance
  # a=(1, 2), b=(-2, 1)
  # A=(4, 3), B=(-5, 0)
  # ax=-2-1=-3, ay=1-2=-1 
  # bx=1-(-2)=3, by=2-1=1 
  # ...........
  # .........A.
  # ......a....
  # ...b.......
  # B....0.....
  defp points_to_antinodes({x1, y1}, {x2, y2}, _max) do
    a1 = {x1 - (x2 - x1), y1 - (y2 - y1)}
    a2 = {x2 - (x1 - x2), y2 - (y1 - y2)}
    # a1 = {2*x1 - x2, 2*y1 - y2}
    # a2 = {2*x2 - x1, 2*y2 - y1}

    [a1, a2]
  end

  defp points_to_antinodes_part2({x1, y1} = p1, {x2, y2} = p2, max) do
    stream1 = antinodes_line(p1, {-(x2 - x1), -(y2 - y1)}, max)
    stream2 = antinodes_line(p2, {-(x1 - x2), -(y1 - y2)}, max)

    Stream.concat(stream1, stream2)
    |> Stream.concat([p1, p2])
  end

  defp antinodes_line(point, {dx, dy}, max) do
    Stream.unfold(point, fn
      {ax, ay} ->
        next = {ax + dx, ay + dy}

        if is_outside?(next, max) do
          nil
        else
          {next, next}
        end
    end)
  end

  defp all_point_pairs([]), do: []
  defp all_point_pairs([_point]), do: []

  defp all_point_pairs([point | rest]) do
    [Enum.map(rest, fn p -> {point, p} end) | all_point_pairs(rest)]
  end

  def debug_visualize(points, {max_x, max_y}) do
    Enum.map(0..(max_y - 1), fn y ->
      line =
        Enum.map(0..(max_x - 1), fn x ->
          if Map.has_key?(points, {x, y}), do: ?#, else: ?.
        end)

      [line, ?\n]
    end)
  end
end
