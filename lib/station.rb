# frozen_string_literal: true

# Station
class Station
  attr_accessor :name

  def initialize(name = '')
    @name = name
    @trains = []
  end

  def trains
    @trains.dup
  end

  def arrivale(train)
    raise TypeError unless train.is_a?(Train)

    @trains.append(train) unless @trains.include?(train)
  end

  def departure(arg)
    case arg
    when Train
      @trains.delete_at(@trains.find_index(arg)) while @trains.include?(arg)
    when Integer
      @trains.delete_at(arg)
    else
      raise TypeError, "#{arg.class} is not valid, need #{Train} or #{Integer}"
    end

    @trains
  end

  def trains_on_type
    trains_on_type = { passenger: [], cargo: [] }

    @trains.each do |t|
      trains_on_type[t.type.to_sym].append(t)
    end

    trains_on_type
  end
end
