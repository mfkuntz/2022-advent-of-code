defmodule Advent.DayEight do
  require Logger
  @path "./lib/days/eight/input_8.txt"

  # @example [
  #   "30373",
  #   "25512",
  #   "65332",
  #   "33549",
  #   "35390"
  # ]

  def run() do
    Logger.info("starting day 8")
    lines = Advent.Utils.read_file_lines!(@path)

    part_1(lines)

    part_2(lines)
  end

  defp part_1(lines) do
    parts = parse_input(lines)

    res =
      Enum.with_index(parts)
      |> Enum.reduce(0, fn {it, i}, acc ->
        iter =
          cond do
            # skip first/last rows
            i == 0 ->
              length(it)

            i == length(parts) - 1 ->
              length(it)

            true ->
              Enum.with_index(it)
              |> Enum.reduce(0, fn {inner, inner_i}, acc ->
                iter =
                  cond do
                    # skip first/last rows
                    inner_i == 0 ->
                      1

                    inner_i == length(parts) - 1 ->
                      1

                    true ->
                      check_part_1(parts, inner, i, inner_i)
                  end

                acc + iter
              end)
          end

        acc + iter
      end)

    Logger.debug("part 1: " <> inspect(res))
  end

  defp part_2(lines) do
    parts = parse_input(lines)

    res =
      Enum.with_index(parts)
      |> Enum.map(fn {it, i} ->
        iter =
          cond do
            # skip first/last rows
            i == 0 ->
              0

            i == length(parts) - 1 ->
              0

            true ->
              Enum.with_index(it)
              |> Enum.map(fn {inner, inner_i} ->
                iter =
                  cond do
                    # skip first/last rows
                    inner_i == 0 ->
                      0

                    inner_i == length(parts) - 1 ->
                      0

                    true ->
                      check_part_2(parts, inner, i, inner_i)
                  end

                iter
              end)
          end

        iter
      end)
      |> Enum.flat_map(fn it ->
        case it do
          i when is_list(i) -> i
          i -> [i]
        end
      end)
      |> Enum.sort(:desc)

    Logger.debug("part 2: " <> inspect(hd(res)))
  end

  defp parse_input(lines) do
    Enum.map(lines, fn it ->
      String.codepoints(it)
      |> Enum.map(fn it ->
        {i, _} = Integer.parse(it)
        i
      end)
    end)
  end

  defp check_part_1(parts, item, x, y) do
    {xl, xr} =
      Enum.at(parts, x)
      |> List.delete_at(y)
      |> Enum.split(y)

    {yl, yr} =
      Enum.map(parts, fn it ->
        Enum.at(it, y)
      end)
      |> List.delete_at(x)
      |> Enum.split(x)

    res =
      with false <- Enum.all?(xl, fn it -> item > it end),
           false <- Enum.all?(xr, fn it -> item > it end),
           false <- Enum.all?(yl, fn it -> item > it end),
           false <- Enum.all?(yr, fn it -> item > it end),
           do: false

    if res do
      1
    else
      0
    end
  end

  defp check_part_2(parts, item, x, y) do
    {xl, xr} =
      Enum.at(parts, x)
      |> List.delete_at(y)
      |> Enum.split(y)

    y_parts =
      Enum.map(parts, fn it ->
        Enum.at(it, y)
      end)

    {yl, yr} =
      y_parts
      |> List.delete_at(x)
      |> Enum.split(x)

    # Logger.debug("-------------")
    # Logger.debug(inspect(Enum.at(parts, x)))
    # Logger.debug(inspect(%{item: item, pos: y}))
    # Logger.debug(inspect(%{xl: Enum.reverse(xl), xr: xr}))
    x1 = reduce_while_inc(Enum.reverse(xl), item)
    x2 = reduce_while_inc(xr, item)
    # Logger.debug("y---")
    # Logger.debug(inspect(y_parts))
    # Logger.debug(inspect(%{item: item, pos: x}))
    # Logger.debug(inspect(%{yl: Enum.reverse(yl), yr: yr}))
    y1 = reduce_while_inc(Enum.reverse(yl), item)
    y2 = reduce_while_inc(yr, item)
    # Logger.debug(inspect(%{x1: x1, x2: x2, y1: y1, y2: y2}))

    res = x1 * x2 * y1 * y2
    # Logger.debug(inspect(res))
    # Logger.debug("-------------")
    res
  end

  defp reduce_while_inc(items, item) do
    Enum.reduce_while(items, 0, fn it, acc ->
      term =
        if it >= item do
          :halt
        else
          :cont
        end

      {term, acc + 1}
    end)
  end
end
