defmodule Advent.DayFive do
  require Logger
  @path "./lib/days/five/input_5.txt"

  # @example [
  #   "    [D]     ",
  #   "[N] [C]     ",
  #   "[Z] [M] [P] ",
  #   " 1   2   3  ",
  #   "",
  #   "move 1 from 2 to 1",
  #   "move 3 from 1 to 3",
  #   "move 2 from 2 to 1",
  #   "move 1 from 1 to 2"
  # ]

  @instructions_re ~r/move (\d+) from (\d+) to (\d+)/

  def run() do
    Logger.info("starting day 5")
    lines = Advent.Utils.read_file_lines!(@path)
    part_1(lines)
    part_2(lines)
  end

  defp part_1(lines) do
    res = run_problem(1, lines)

    Logger.debug("part 1: ")
    Logger.debug(inspect(res))

    solution =
      Enum.reduce(res, "", fn {_, it}, acc ->
        acc <> hd(it)
      end)

    Logger.debug(inspect(solution))
  end

  defp part_2(lines) do
    res = run_problem(2, lines)

    Logger.debug("part 2: ")
    Logger.debug(inspect(res))

    solution =
      Enum.reduce(res, "", fn {_, it}, acc ->
        acc <> hd(it)
      end)

    Logger.debug(inspect(solution))
  end

  # hey my solution works for both parts :)
  defp run_problem(number, lines) do
    {state, instructions} = build_input(lines)

    Enum.reduce(instructions, state, fn it, acc ->
      [_, count, src, dest] = Regex.run(@instructions_re, it)
      {count, _} = Integer.parse(count)
      to_move = Map.get(acc, src) |> Enum.take(count)

      # for problem 2 we skip the reverse
      to_move =
        if number == 1 do
          Enum.reverse(to_move)
        else
          to_move
        end

      acc
      |> Map.update!(src, fn existing ->
        existing -- to_move
      end)
      |> Map.update!(dest, fn existing ->
        to_move ++ existing
      end)
    end)
  end

  defp build_input(input) do
    [state, instructions] =
      input
      |> Enum.chunk_by(fn it -> it == "" end)
      |> Enum.filter(fn it -> it != [""] end)

    {_, state} = List.pop_at(state, -1)

    res =
      Enum.reduce(state, %{}, fn it, acc ->
        chunks =
          it
          |> String.codepoints()
          # each [x] is 4 chars long
          |> Enum.chunk_every(4)
          |> Enum.map(fn it ->
            # position 1 is the actual Letter
            case Enum.at(it, 1) do
              " " -> ""
              c -> c
            end
          end)
          # start at idx 1 since instructions are indexed from 1
          |> Enum.with_index(1)
          |> Enum.reduce(acc, fn it, acc ->
            {crate, idx} = it

            # skip empty crates
            if crate == "" do
              acc
            else
              {_, r} =
                Map.get_and_update(acc, Integer.to_string(idx), fn val ->
                  v =
                    if val == nil do
                      []
                    else
                      val
                    end

                  {val, v ++ [crate]}
                end)

              r
            end
          end)

        chunks
      end)

    Logger.debug(inspect(res))
    Logger.debug(inspect(instructions))
    {res, instructions}
  end
end
