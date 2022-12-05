defmodule Advent.DayTwo do
  require Logger
  @path "./lib/days/two/input_2.txt"

  # @example [
  #   "A Y",
  #   "B X",
  #   "C Z"
  # ]

  def run() do
    Logger.info("starting day 2")
    lines = Advent.Utils.read_file_lines!(@path)
    part_1(lines)
    part_2(lines)
  end

  @o_r "A"
  @o_p "B"
  @o_s "C"

  @p_r "X"
  @p_p "Y"
  @p_s "Z"

  defp part_1(lines) do
    total =
      lines
      |> Enum.map(fn it ->
        [o, p] = String.split(it)

        score =
          case o do
            @o_r ->
              case p do
                @p_r -> 3
                @p_p -> 6
                @p_s -> 0
              end

            @o_p ->
              case p do
                @p_r -> 0
                @p_p -> 3
                @p_s -> 6
              end

            @o_s ->
              case p do
                @p_r -> 6
                @p_p -> 0
                @p_s -> 3
              end
          end

        selection =
          case p do
            @p_r -> 1
            @p_p -> 2
            @p_s -> 3
          end

        score + selection
      end)
      |> Enum.sum()

    Logger.debug("part 1: " <> inspect(total))
  end

  defp part_2(lines) do
    total =
      lines
      |> Enum.map(fn it ->
        [o, p] = String.split(it)

        {score, selection} =
          case o do
            @o_r ->
              case p do
                # lose
                @p_r -> {0, 3}
                # draw
                @p_p -> {3, 1}
                # win
                @p_s -> {6, 2}
              end

            @o_p ->
              case p do
                @p_r -> {0, 1}
                @p_p -> {3, 2}
                @p_s -> {6, 3}
              end

            @o_s ->
              case p do
                @p_r -> {0, 2}
                @p_p -> {3, 3}
                @p_s -> {6, 1}
              end
          end

        score + selection
      end)
      |> Enum.sum()

    Logger.debug("part 2: " <> inspect(total))
  end
end
