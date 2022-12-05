defmodule Advent.DayFour do
  require Logger
  @path "./lib/days/four/input_4.txt"

  # @example [
  #   "2-4,6-8",
  #   "2-3,4-5",
  #   "5-7,7-9",
  #   "2-8,3-7",
  #   "6-6,4-6",
  #   "2-6,4-8"
  # ]

  def run() do
    Logger.info("starting day 4")
    lines = Advent.Utils.read_file_lines!(@path)
    part_1(lines)
    part_2(lines)
  end

  defp part_1(lines) do
    total =
      lines
      |> Enum.map(fn it ->
        [pa, pb] = String.split(it, ",")
        ra = new_range(pa) |> new_map()
        rb = new_range(pb) |> new_map()

        sub_a = MapSet.subset?(ra, rb)
        sub_b = MapSet.subset?(rb, ra)

        if sub_a || sub_b do
          1
        else
          0
        end
      end)
      |> Enum.sum()

    Logger.debug("part 1: " <> inspect(total))
  end

  defp part_2(lines) do
    total =
      lines
      |> Enum.map(fn it ->
        [pa, pb] = String.split(it, ",")
        ra = new_range(pa) |> new_map()
        rb = new_range(pb) |> new_map()

        intersect =
          MapSet.intersection(ra, rb)
          |> MapSet.size()

        if intersect == 0 do
          0
        else
          1
        end
      end)
      |> Enum.sum()

    Logger.debug("part 2: " <> inspect(total))
  end

  defp new_range(r) do
    [a_str, b_str] = String.split(r, "-")
    {a, _} = Integer.parse(a_str)
    {b, _} = Integer.parse(b_str)
    Range.new(a, b)
  end

  defp new_map(lines), do: MapSet.new(lines)
end
