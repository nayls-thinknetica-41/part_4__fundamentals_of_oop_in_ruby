# frozen_string_literal: true

require 'rspec'

describe 'Station' do
  require 'faker'
  require_relative '../lib/station'
  require_relative '../lib/train'

  before do
    @station = Station.new(Faker::Lorem.word)

    @trains = []
    10.times do
      @trains.append(
        Train.new(
          Faker::Number.number(digits: 10),
          rand(0..1).eql?(0) ? :passenger : :cargo,
          Faker::Number.number(digits: 2)
        )
      )
    end
  end

  after do
    # Do nothing
  end

  context 'Имеет' do
    it 'пустой сетап' do
      station = Station.new
      expect(station.nil?)
      expect(station.name).to eq('')
      expect(station.trains).to eq([])
      expect(station).is_a?(Station)
    end

    it 'название, которое указывается при создании' do
      expected_station_name = Faker::Lorem.word

      expect(Station.new(expected_station_name).name).to eq(expected_station_name)
    end
  end

  context 'Может' do
    it 'принимать поезда (по одному за раз)' do
      expect { @station.arrivale(@trains) }.to raise_error(TypeError)
      expect(@station.trains.size).to eq(0)

      @station.trains.append(@trains.first)
      expect(@station.trains.size).to eq(0)

      @station.arrivale(@trains.first)
      expect(@station.trains.first).to eq(@station.trains.first)
    end

    it 'возвращать список всех поездов на станции, находящихся в текущий момент' do
      @trains.each { |t| @station.arrivale(t) }

      expect(@station.trains.size).to eq(10)
      expect(@station.trains).to eq(@trains)
    end

    it 'возвращать список поездов на станции по типу' do
      @trains.each { |t| @station.arrivale(t) }

      expect(@station.trains.size).to eq(10)
      expect(@station.trains).to eq(@trains)

      trains_on_type = { passenger: [], cargo: [] }
      @station.trains.each { |t| trains_on_type[t.type.to_sym].append(t) }

      expect(@station.trains_on_type.nil?).to eq(false)
      expect(@station.trains_on_type.key?(:passenger)).to eq(true)
      expect(@station.trains_on_type.key?(:cargo)).to eq(true)
      expect(@station.trains_on_type[:passenger].nil?).to eq(false)
      expect(@station.trains_on_type[:cargo].nil?).to eq(false)
      expect(@station.trains_on_type).to eq(trains_on_type)
    end

    it 'может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции)' do
      @trains.each { |t| @station.arrivale(t) }

      expect(@station.trains.size).to eq(10)

      @station.departure(@trains.first)
      @station.departure(@trains.last)

      expect(@station.trains.size).to eq(8)
    end
  end
end
