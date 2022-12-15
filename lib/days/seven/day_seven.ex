defmodule Advent.DaySeven.Dir do
  @derive {Jason.Encoder, only: [:type, :name, :size, :children]}
  defstruct [:type, :name, :children, :size, :parent]
end

defmodule Advent.DaySeven do
  require Logger
  # @example_path "./lib/days/seven/input_7_example.txt"
  @path "./lib/days/seven/input_7.txt"

  @file_re ~r/(\d+)(.*)/

  @fs_total 70_000_000
  @fs_needed 30_000_000

  alias Advent.DaySeven.Dir

  def run() do
    Logger.info("starting day 7")
    lines = Advent.Utils.read_file_lines!(@path)
    # example = Advent.Utils.read_file_lines!(@example_path)

    part_1(lines)

    part_2(lines)
  end

  defp part_1(lines_raw) do
    res = parse_input(lines_raw)

    # File.write!("tree.json", Jason.encode!(res, pretty: true))

    flatten =
      res.children
      |> Enum.map(fn it ->
        if it.type == :dir do
          c = child_dirs(it)
          [it] ++ c
        else
          [it]
        end
      end)
      |> Enum.flat_map(fn it -> it end)

    # File.write!("flatten.json", Jason.encode!(flatten, pretty: true))

    res =
      flatten
      |> Enum.reduce(0, fn it, acc ->
        s = it.size

        if it.type == :dir && s <= 100_000 do
          # Logger.debug("found -> " <> it.name)
          # Logger.debug(inspect(s))
          acc + s
        else
          acc
        end
      end)

    Logger.debug("part 1: " <> inspect(res))
  end

  defp part_2(lines_raw) do
    res = parse_input(lines_raw)

    flatten =
      res.children
      |> Enum.map(fn it ->
        if it.type == :dir do
          c = child_dirs(it)
          [it] ++ c
        else
          [it]
        end
      end)
      |> Enum.flat_map(fn it -> it end)

    start_free_space = @fs_total - res.size
    needed = @fs_needed - start_free_space

    dirs =
      flatten
      |> Enum.filter(fn it -> it.type == :dir && it.size >= needed end)
      |> Enum.sort_by(fn it -> it.size end)

    dir = hd(dirs)

    Logger.debug("part 2: ")
    Logger.debug(dir.name <> ": " <> inspect(dir.size))
  end

  defp parse_input(lines) do
    root = new_dir("/", nil)

    cwd =
      lines
      |> Enum.reduce(root, fn it, cwd ->
        cond do
          it == "$ cd /" ->
            root

          it == "$ cd .." ->
            parent_dir(cwd)

          String.starts_with?(it, "$ cd") ->
            dir_name = parse_dir_name(it)
            d = new_dir(dir_name, cwd)
            push_dir(cwd, d)
            d

          it == "$ ls" ->
            cwd

          true ->
            case Regex.run(@file_re, it) do
              [_, size, name] ->
                f = new_file(size, name)
                push_file(cwd, f)

              _ ->
                cwd
            end
        end
      end)

    root_dir(cwd)
  end

  defp child_dirs(%Dir{children: c}) do
    c ++
      Enum.flat_map(c, fn it ->
        if it.type == :dir do
          child_dirs(it)
        else
          [it]
        end
      end)
  end

  defp child_dirs(it) do
    it
  end

  defp parse_dir_name(name) do
    case String.contains?(name, "$") do
      true ->
        Enum.at(String.split(name, "$ cd"), 1)
        |> String.trim()

      _ ->
        name
    end
  end

  defp new_dir(name, p) do
    n = parse_dir_name(name)

    %Dir{type: :dir, name: n, children: [], parent: p, size: 0}
  end

  defp new_file(size_str, name) do
    {size, _} = Integer.parse(size_str)
    %{type: :file, name: name, size: size}
  end

  defp push_dir(cwd, dir) do
    cwd
    |> Map.update!(:size, fn it ->
      it + dir.size
    end)
    |> Map.update!(:children, fn it ->
      it ++ [dir]
    end)
  end

  defp push_file(cwd, file) do
    cwd
    |> Map.update!(:size, fn it ->
      it + file.size
    end)
    |> Map.update!(:children, fn it ->
      it ++ [file]
    end)
  end

  defp parent_dir(cwd) do
    {p, c} = Map.pop(cwd, :parent)

    push_dir(p, c)
  end

  defp root_dir(%Dir{parent: p} = d) when not is_nil(p) do
    p = parent_dir(d)
    root_dir(p)
  end

  defp root_dir(p), do: p
end
