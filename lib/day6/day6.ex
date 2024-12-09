defmodule Aoc2024.Day6 do
  require Logger

  def part1() do
    part1(load_input())
  end

  def part1(input) do
    board = parse_input(input)
    guard_pos = find_guard(board)

    positions = calculate_moves(board, guard_pos, %{})
    map_size(positions) + 1
  end

  defp load_input() do
    File.read!("lib/day6/input.txt")
  end

  defp parse_input(input) do
    String.splitter(input, "\n", trim: true)
    |> Stream.map(fn line ->
      line
      |> String.to_charlist()
      |> Stream.with_index()
      |> Stream.filter(fn {el, _} -> el in [?#, ?^, ?>, ?v, ?<] end)
      |> Stream.map(&swap_tuple/1)
      |> Enum.into(%{})
    end)
    |> Stream.with_index()
    |> Stream.map(&swap_tuple/1)
    |> Enum.into(%{})
  end

  defp find_guard(board) do
    Enum.find_value(board, fn {row_index, row} ->
      Enum.find_value(row, fn {col_index, value} ->
        if is_player?(value) do
          {row_index, col_index}
        else
          nil
        end
      end)
    end)
  end

  defp swap_tuple({a, b}), do: {b, a}

  defp is_player?(char) when is_integer(char) do
    Map.has_key?(%{?^ => true, ?> => true, ?v => true, ?< => true}, char)
  end

  defp calculate_moves(board, {row, col} = guard_pos, old_positions) when not is_nil(guard_pos) do
    guard = get_in(board[row][col])
    move_guard(board, guard_pos, guard, old_positions)
  end

  defp move_guard(board, guard_pos, guard, old_positions)
  defp move_guard(_board, nil, _guard, old_positions), do: old_positions

  defp move_guard(board, {row, col} = guard_pos, guard, old_positions) do
    {next_row, next_col, rotated} =
      case guard do
        ?^ -> {row - 1, col, ?>}
        ?> -> {row, col + 1, ?v}
        ?< -> {row, col - 1, ?^}
        ?v -> {row + 1, col, ?<}
      end

    obstacle = get_in(board[next_row][next_col])

    {_, board} = pop_in(board[row][col])

    if obstacle == nil do
      Logger.debug("no obstacle at {#{next_row}, #{next_col}} moving there")

      try do
        board = put_in(board[next_row][next_col], guard)
        calculate_moves(board, {next_row, next_col}, Map.put(old_positions, guard_pos, true))
      rescue
        _ in ArgumentError -> old_positions
      end
    else
      Logger.debug("deadend at {#{row}, #{col}}, rotated #{List.to_string([rotated])}")
      board = put_in(board[row][col], rotated)
      calculate_moves(board, guard_pos, Map.put(old_positions, guard_pos, true))
    end
  end
end
