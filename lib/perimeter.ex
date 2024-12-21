# THIS IS AI generated!!!
defmodule Aoc2024.Perimeter do
  @doc """
  Calculates the perimeter of a shape from a set of points, including internal points.
  Handles special cases of 1 or 2 points, otherwise uses convex hull algorithm.
  """
  def calculate_with_internals(points) when length(points) <= 2 do
    case points do
      # Single point has no perimeter
      [_single_point] -> 0.0
      # Two points - perimeter is twice the distance between them
      [p1, p2] -> distance(p1, p2) * 2
      # Empty list - return 0 or raise error based on your requirements
      [] -> 0.0
    end
  end

  def calculate_with_internals(points) do
    points
    |> find_convex_hull()
    |> calculate_perimeter()
  end

  @doc """
  Implements Graham's scan algorithm to find the convex hull (boundary points).
  Now handles cases with fewer than 3 points.
  """
  def find_convex_hull(points) when length(points) <= 2, do: points

  def find_convex_hull(points) do
    # Find the point with lowest y-coordinate (and leftmost if tied)
    anchor = Enum.min_by(points, fn {x, y} -> {y, x} end)

    # Sort other points by polar angle relative to anchor point
    sorted_points =
      points
      |> MapSet.delete(anchor)
      |> Enum.sort_by(fn point ->
        {polar_angle(anchor, point), distance(anchor, point)}
      end)

    # Initialize hull with first three points
    [p2, p3 | rest] = sorted_points
    initial_hull = [p3, p2, anchor]

    # Build the hull by processing remaining points
    Enum.reduce(rest, initial_hull, fn point, hull ->
      process_point(point, hull)
    end)
  end

  defp process_point(point, [h1, h2 | hull] = current_hull) do
    if ccw(h2, h1, point) >= 0 do
      [point | current_hull]
    else
      process_point(point, [h2 | hull])
    end
  end

  @doc """
  Calculates the polar angle between two points relative to horizontal.
  """
  def polar_angle({x1, y1}, {x2, y2}) do
    :math.atan2(y2 - y1, x2 - x1)
  end

  @doc """
  Determines if three points make a counterclockwise turn.
  Returns positive if CCW, negative if CW, 0 if collinear.
  """
  def ccw({x1, y1}, {x2, y2}, {x3, y3}) do
    (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)
  end

  @doc """
  Calculates distance between two points.
  """
  def distance({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1
    :math.sqrt(dx * dx + dy * dy)
  end

  @doc """
  Calculates perimeter once we have the boundary points.
  """
  def calculate_perimeter(boundary_points) do
    # Create pairs of consecutive points, including last-to-first connection
    point_pairs =
      Enum.zip(
        boundary_points,
        Enum.slice(boundary_points, 1..-1//1) ++ [List.first(boundary_points)]
      )

    # Sum up the distances between all pairs
    Enum.reduce(point_pairs, 0, fn {p1, p2}, acc ->
      acc + distance(p1, p2)
    end)
  end
end
