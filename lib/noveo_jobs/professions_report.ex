# Load CSV files
defmodule ProfessionsReport do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: ProfessionsReport)
  end

  @impl true
  def init(_) do
    CsvLoader.fill_database()
    professions =
      CsvLoader.load_professions()
      |> Enum.drop(1) # drop header
      |> Enum.map(fn({:ok, [i, _, category]}) -> {i, category} end)
      |> Map.new() # return map where key is number and category is value
    init_report()
    {:ok, build_report()}
  end

  def get() do
    GenServer.call(ProfessionsReport, :get)
  end

  def get_rendered() do
    get() |> render
  end

  @impl true
  def handle_call(:get, _from, %{professions: professions, report: report}) do
    {:reply, report, %{professions: professions, report: report}}
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

  def build_report() do
    professions =
      CsvLoader.load_professions()
      |> Enum.drop(1) # drop header
      |> Enum.map(fn({:ok, [i, _, category]}) -> {i, category} end)
      |> Map.new() # return map where key is number and category is value

    categories_continents =
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

    categories_continents =
      categories_continents
      |> Enum.map(fn {category, lat, lon} -> { category, GeoServices.get_continent(lat, lon) } end)
      |> Enum.filter(fn{category, continent} -> category != nil and continent != nil and continent != "N/A" end)

    report = init_report()
    report = Enum.reduce(categories_continents, report, fn (x,acc) -> add(acc, x) end )

    %{professions: professions, report: report}
  end

  @impl true
  def handle_cast({:add, {category, continent}}, %{professions: professions, report: report}) do
    report = add(report, {category, continent})
    {:noreply, %{professions: professions, report: report}}
  end

  def add({category, continent}) do
    GenServer.cast(ProfessionsReport, {:add, {category, continent}})
  end

  def add(report, {category, continent}) do
    # Probably ETS will be better choice for the immutable stuff like this

    new_data = %{report[continent] | category => report[continent][category] + 1}
    report = %{report | continent => new_data}

    new_data = %{report[continent] | "Total" => report[continent]["Total"] + 1}
    report = %{report | continent => new_data}

    new_data = %{report["Total"] | category => report["Total"][category] + 1}
    report = %{report | "Total" => new_data}

    new_data = %{report["Total"] | "Total" => report["Total"]["Total"] + 1}
    %{report | "Total" => new_data}
  end

  def init_report() do
    categories = CsvLoader.load_professions()
    |> Enum.drop(1)
    |> Enum.group_by(fn({:ok, [_, _, category]}) -> category end)
    |> Map.keys()

    categories = ["Total" | categories]
    |> Enum.map(fn x -> {x, 0} end)
    |> Map.new()

    ["Total" | GeoServices.get_continents()]
    |> Enum.map(fn x -> {x, categories} end)
    |> Map.new()
  end

  def render(table) do
    map_to_list = fn(map) ->
      Map.to_list(map)
      |> Enum.map(fn{k, v} -> v end)
      |> Enum.reverse() # move Total to the beginning

    end

    header = [" " | Enum.reverse(Map.keys(table["Total"]))]

    table =
      table
      |> Map.to_list()
      |> Enum.map(fn({k, map}) -> [k | map_to_list.(map)] end)
      |> Enum.reverse() # total Total to the beginning

    [header | table]
  end


end