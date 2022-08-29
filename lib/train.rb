# frozen_string_literal: true

# Train
class Train
  attr_accessor :number, :wagon_size, :speed
  attr_reader :route, :type

  def initialize(number = 0, type = :passenger, wagon_size = 0)
    @number = number
    @type = type
    @wagon_size = wagon_size
    @speed = 0
    @route = { previous: nil, current: nil, next: nil, routes_list: [] }
  end

  def route=(route)
    if @route[:routes_list].empty?
      @route[:previous] = nil
      @route[:current] = route.routes.first unless route.routes.first.nil?
      @route[:next] = route.routes.last unless route.routes.last.nil?
      @route[:routes_list] = route.routes
    end
  end

  def type=(type)
    if %i[passenger cargo].include?(type)
      @type = type
    else
      raise Error 'invalid value, need [:passenger, :cargo]'
    end
  end

  def attach
    self.wagon_size += 1 if self.speed.eql?(0)
  end

  def unpin
    self.wagon_size -= 1 if self.speed.eql?(0)
  end

  def forward
    unless @route[:routes_list].empty?
      cur_index = @route[:routes_list].find_index(@route[:current])

      if (cur_index < @route[:routes_list].size) && !@route[:next].nil?
        @route[:previous] = @route[:current]
        @route[:current] = @route[:next]

        if @route[:current] == @route[:routes_list].last
          @route[:next] = nil
        else
          @route[:next] = @route[:routes_list][cur_index + 1]
        end
      end
    end
  end

  def backward
    unless @route[:routes_list].empty?
      cur_index = @route[:routes_list].find_index(@route[:current])

      if (cur_index > 0) && !@route[:previous].nil?
        @route[:next] = @route[:current]
        @route[:current] = @route[:previous]

        if @route[:current] == @route[:routes_list].first
          @route[:previous] = nil
        else
          @route[:previous] = @route[:routes_list][cur_index - 1]
        end
      end
    end
  end
end
