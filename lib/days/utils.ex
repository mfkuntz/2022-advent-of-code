defmodule Advent.Utils do
  require Logger

  def read_file_lines!(path) do
    path = Path.relative_to_cwd(path)
    Logger.debug("reading file input: " <> inspect(path))

    d =
      case File.read(path) do
        {:ok, d} ->
          d

        {:error, reason} ->
          Logger.error("error reading input file: " <> to_string(:file.format_error(reason)))
          raise to_string(reason)
      end

    String.split(d, "\n")
  end
end
