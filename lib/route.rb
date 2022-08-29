# frozen_string_literal: true

# Route
class Route
  def initialize(start_station = nil, end_station = nil)
    @routes = [start_station, end_station]
  end

  def routes
    @routes.dup
  end

  def insert(station)
    if @routes.size > 1
      @routes.insert(@routes.size - 1, station)
    else
      @routes.push(station)
    end
  end

  def delete(station)
    @routes.delete(station) if @routes.size > 2
  end
end
