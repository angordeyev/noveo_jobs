# Load CSV files
defmodule ProfessionsReport do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: ProfessionsReport)
  end

  @impl true
  def init(_) do
    professions =
      CsvLoader.load_professions()
      |> Enum.drop(1) # drop header
      |> Enum.map(fn({:ok, [i, _, category]}) -> {i, category} end)
      |> Map.new() # return map where key is number and category is value
    {:ok, %{professions: professions, report: []}}
  end

  def build_report() do
    GenServer.call(ProfessionsReport, :build_report)
  end

  @impl true
  def handle_call(:build_report, _from, %{professions: professions, report: report}) do
    report =
      CsvLoader.load_jobs()
      |> Enum.drop(1) # drop header
      |> Enum.map(fn({:ok, [profession_id, _, _,lat, lon]}) ->
        lat = case Float.parse(lat) do
          {lat, _}  -> lat
          _ -> nil
        end
        lon = case Float.parse(lon) do
          {lon, _}  -> lon
          _ -> nil
        end
        {professions[profession_id], lat, lon}
      end)
      |> Enum.filter(fn({category, lat, lon}) -> lat != nil and lon != nil end) # filter the entries which does not have lat or lon


    report = report |> Enum.map(fn {category, lat, lon} -> { category, GeoServices.get_continent(lat, lon) } end)

    {:reply, report, %{professions: professions, report: report}}
  end

  def add({category, continent}) do

  end

  def init_table() do
    categories = CsvLoader.load_professions()
    |> Enum.drop(1)
    |> Enum.group_by(fn({:ok, [_, _, category]}) -> category end)
    |> Map.keys()

    categories = ["Total" | categories]
    |> Enum.map(fn x -> {x, nil} end)
    |> Map.new()

    ["Total" | GeoServices.get_continents()]
    |> Enum.map(fn x -> {x, categories} end)
    |> Map.new()
  end

  def render(table) do
    map_to_list = fn(map) ->
      Map.to_list(map)
      |> Enum.reverse() # move Total to the beginning
      |> Enum.map(fn{k, v} -> v end)

    end

    header = [" " | Map.keys(table["Total"])]

    table =
      table
      |> Map.to_list()
      |> Enum.map(fn({k, map}) -> [k | map_to_list.(map)] end)
      |> Enum.reverse() # total Total to the beginning

    [header | table]
  end

end