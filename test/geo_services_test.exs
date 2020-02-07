defmodule GeoServicesTest do
  use ExUnit.Case

 test "continent" do
    assert GeoServices.get_continent(59.8704128, 30.1768704) == "Europe"
    assert GeoServices.get_continent(37.07215774691171, 106.47744002851533) == "Asia"
    assert GeoServices.get_continent(-14.88175668252757, 22.146385341015336) == "Africa"
    assert GeoServices.get_continent(41.950804730802965,-100.19736465898467) == "North America"
    assert GeoServices.get_continent(-11.631394271937506,-59.54795059648467) == "South America"
    assert GeoServices.get_continent(-73.00353578997444,23.245018153515336) == "Antarctica"
    assert GeoServices.get_continent(-24.547753325506,135.61318221601533) == "Australia"
    assert GeoServices.get_continent(-73.00353578997444,23.245018153515336) != "Europe" # Antarctica
  end


  test "random coordinates" do
     assert match?([_, _], GeoServices.random_coordinates())
  end





end
