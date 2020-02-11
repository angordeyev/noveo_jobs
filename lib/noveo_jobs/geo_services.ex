defmodule GeoServices do


  # This approach is chosen as fastest.
  # The coordinates are taken from https://stackoverflow.com/questions/13905646/get-the-continent-given-the-latitude-and-longitude
  # The result will be good for the major geographic areas
  # If you plan to distinguish by country local-reverse-geocoder may be the choice
  # https://github.com/tomayac/local-reverse-geocoder
  # or the payed version of Geo Services like Google, SteetMap, geonames.org, etc. because the
  # free versions are limited by a number of requests per second
  # As the number of continents are not large the data is not indexed here, otherwise rtee indexing should be used
  # It will give more than 80 000 result per second on the average computer using parallel execution, e.g. with Flow
  # 100 000 000 records database will be indexed in 25 minutes
  def get_continent(latitude, longitude) do
    shapes = ContinentShapes.continent_shapes()
    point = [latitude, longitude]
    cond do
      Geocalc.within?(shapes.north_america_1, point) -> "North America"
      Geocalc.within?(shapes.north_america_2, point) -> "North America"
      Geocalc.within?(shapes.south_america, point) -> "South America"
      Geocalc.within?(shapes.eur, point) -> "Europe"
      Geocalc.within?(shapes.afr, point) -> "Africa"
      Geocalc.within?(shapes.aus, point) -> "Australia"
      Geocalc.within?(shapes.asia1, point) -> "Asia"
      Geocalc.within?(shapes.asia2, point) -> "Asia"
      Geocalc.within?(shapes.antarctica, point) -> "Antarctica"
      true -> "N/A"
    end
  end

  # The function to convert continent coordinates from
  # https://stackoverflow.com/questions/13905646/get-the-continent-given-the-latitude-and-longitude
  def merge_latitue_longitue_lists(latitude_list, longitude_list) do
    parse_float = fn x ->
      case Float.parse(x) do
        {r, _} -> r
        _ -> raise ArgumentError, message: "Invalid arguments format"
      end
    end
    parse_to_float_list = fn string_list ->
      String.split(string_list)
      |> Enum.map(parse_float)
    end
    latitude_float_list = parse_to_float_list.(latitude_list)
    longitude_float_list = parse_to_float_list.(longitude_list)
    Enum.zip(latitude_float_list, longitude_float_list)
    |> Enum.map(fn {lat, lon} -> [lat, lon] end)
  end

  # Getting random coordinates for test purposes
  def random_coordinates() do
    random = fn(min, max) -> :rand.uniform(max - min + 1) + min - 1 end
    random_fractional = fn -> random.(0, 100) / 100 end # random fractional part 0 - 1
    latitude = random.(-90, 89)
    longitude = random.(-100, 99)
    [latitude + random_fractional.(), longitude + random_fractional.()]
  end

  # Get all continents
  def get_continents do
    ["Europe", "Asia", "Africa", "Australia", "North America", "South America", "Antarctica"]
  end



  # def distance_between() do
  #   Geocalc.distance_between(point_1, point_2)
  # end


  def post_command(command, params_map \\ %{}) do
    # params = "command=#{command}&nonce=#{nonce}" <> map_to_html_params(params_map)
    # Logger.debug params
    # case HTTPoison.post("https://poloniex.com/tradingApi", params, %{"Key" => key, "Sign" => sign(params), "Content-Type" => "application/x-www-form-urlencoded"}) do
    #   {:ok, %HTTPoison.Response{body: body} } ->
    #     {:ok, Poison.decode! body}
    #   {:error, message}  ->
    #     message |> inspect |> Logger.error
    #     {:error, message}
    # end
  end

  def performance_test do
    1..80000
    |> Flow.from_enumerable()
    |> Flow.map(fn x -> GeoServices.random_coordinates() end)
    |> Flow.map(fn([lat, lon]) -> [lat, lon, get_continent(lat, lon)]  end)
    |> Enum.to_list()
  end

end
