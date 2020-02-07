# Load CSV files
defmodule CsvLoader do

  def load_jobs() do
    load_csv("technical-test-jobs.csv")
  end

  def load_professions() do
    load_csv("technical-test-professions.csv")
  end

  defp load_csv(file) do
    "../../test/test_files/#{file}"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode
    |> Enum.to_list()
  end

end


