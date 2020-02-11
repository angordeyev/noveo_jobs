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

  # Filling the database with CSV files roughly without any optimization
  # Filling take place only if the database is empty
  # Can be replaced by bulk insert for performance
  def fill_database() do
    if NoveoJobs.Repo.aggregate(Continent, :count, :id) == 0 do
      NoveoJobs.Repo.insert(%Continent{name: "South America"})
      NoveoJobs.Repo.insert(%Continent{name: "North America"})
      NoveoJobs.Repo.insert(%Continent{name: "Europe"})
      NoveoJobs.Repo.insert(%Continent{name: "Australia"})
      NoveoJobs.Repo.insert(%Continent{name: "Asia"})
      NoveoJobs.Repo.insert(%Continent{name: "Africa"})
      NoveoJobs.Repo.insert(%Continent{name: "Antarctica"})
    end

    if NoveoJobs.Repo.aggregate(Job, :count, :id) == 0 do
      continents =
        NoveoJobs.Repo.all(Continent)
        |> Enum.map(fn(%Continent{id: id, name: name}) -> [id, name] end)
        |> Map.new(fn [v, k] -> {k, v} end)

      load_jobs()
      |> Enum.drop(1)
      |> Enum.map(fn({:ok, [profession_id, contract_type, name, lat, lon]}) ->

        with {profession_id_integer, _} <- Integer.parse(profession_id),
             {lat_float, _} <- Float.parse(lat),
             {lon_float, _} <- Float.parse(lon)
         do
          continent_name = GeoServices.get_continent(lat_float, lon_float)
          continent_id = continents[continent_name]
          if profession_id_integer < 42 do
            NoveoJobs.Repo.insert(%Job{continent_id: continent_id, profession_id: profession_id_integer, contract_type: contract_type, name: name, location: %Geo.Point{coordinates: {lat_float, lon_float}} })
          end
        end
      end)
    end

    if NoveoJobs.Repo.aggregate(Profession, :count, :id) == 0 do
      load_professions()
      |> Enum.drop(1)
      |> Enum.map(fn({:ok, [_id, name, category_name]}) ->
        NoveoJobs.Repo.insert(%Profession{name: name, category_name: category_name })
      end)
    end
  end

end


