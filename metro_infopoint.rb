require 'yaml'
require 'pry'
class MetroInfopoint
  attr_reader :timing, :data

  def initialize
    @timing = YAML.load_file('C:\Users\zarichnyi_v\Desktop\metro-infopoint-master\config\timing2.yml')['timing']
    @data = YAML.load_file('C:\Users\zarichnyi_v\Desktop\metro-infopoint-master\config\config.yml')['stations']
  end

  def calculate(from_station, to_station)
    { price: calculate_price(from_station, to_station),
      time: calculate_time(from_station, to_station) }
  end

  def calculate_price(from_station, to_station)
    return if from_station == to_station

    price = find_simple_route(from_station, to_station, 'price')

    return price if price

    first_line = data[from_station.to_s]
    second_line = data[to_station.to_s]

    if first_line[0] == second_line[0]
      find_route_bettwin_stations(from_station, to_station, 'price', first_line[0])
    end
  end 

  def calculate_time(from_station, to_station)
    time = find_simple_route(from_station, to_station, 'time')
    return time if time

    first_line = data[from_station.to_s]
    second_line = data[to_station.to_s]

    if first_line[0] == second_line[0]
      find_route_bettwin_stations(from_station, to_station, 'time', first_line[0])
    end

  end

  private

  def find_route_bettwin_stations(from_station, to_station, unit_type, line)
    # lines = @data.select { |k, val| val[0] == line }.keys
    stations = []
    timing.select do |s|
      data[s['start'].to_s][0] == line && data[s['end'].to_s][0] == line 
    end.each { |el| stations << el[unit_type]; break if el['end'] == to_station}

    stations.sum
  end

  def find_simple_route(from_s, to_sn, unit_type)
    route = timing.select { |s| s['start'] == from_s && s['end'] == to_sn }
    route[0][unit_type] unless route.empty?
  end
end

puts MetroInfopoint.new.calculate(:donetska, :granychna)
