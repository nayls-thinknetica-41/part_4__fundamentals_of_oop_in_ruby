# frozen_string_literal: true

require 'rspec'

describe 'Train' do
  require 'faker'
  require_relative '../lib/route'
  require_relative '../lib/station'
  require_relative '../lib/train'

  before do
    # Do nothing
    @train = Train.new(
      Faker::Number.number(digits: 10),
      rand(0..1).eql?(0) ? :passenger : :cargo,
      Faker::Number.number(digits: 2)
    )

    @st1 = Station.new(Faker::Lorem.word)
    @st2 = Station.new(Faker::Lorem.word)
    @st3 = Station.new(Faker::Lorem.word)

    @rt1 = Route.new(@st1, @st3)
    @rt2 = Route.new(@st1, @st3)
  end

  after do
    # Do nothing
  end

  context 'Имеет' do
    it 'номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса' do
      train_number = Faker::Number.number(digits: 10)
      train_type = rand(0..1).eql?(0) ? :passenger : :cargo
      train_wagon_size = Faker::Number.number(digits: 2)

      train = Train.new(train_number, train_type, train_wagon_size)

      expect(train.number).to eq(train_number)
      expect(train.type).to eq(train_type)
      expect(train_wagon_size).to eq(train_wagon_size)
    end
  end

  context 'Может' do
    it 'набирать скорость' do
      expect(@train.speed).to eql(0)

      @train.speed = 15
      expect(@train.speed).to eql(15)
    end

    it 'возвращать текущую скорость' do
      @train.speed = 10
      expect(@train.speed).to eql(10)
    end

    it 'тормозить (сбрасываь скорость до нуля)' do
      @train.speed = 10
      expect(@train.speed).to eql(10)

      @train.speed = 0
      expect(@train.speed).to eql(0)
    end

    it 'возвращать количество вагонов' do
      expect(@train.wagon_size).not_to eql(nil)
      expect(@train.wagon_size.class).to eql(Integer)
    end

    it 'прицеплять/отцеплять вагоны только если поезд не движется' do
      cur_wagon_size = @train.wagon_size
      expect(@train.wagon_size).not_to eql(nil)

      @train.speed = 120
      expect(@train.speed).to eql(120)

      @train.attach
      expect(@train.wagon_size).not_to eql(cur_wagon_size + 1)

      @train.unpin
      expect(@train.wagon_size).not_to eql(cur_wagon_size - 1)

      @train.speed = 0

      @train.attach
      expect(@train.wagon_size).to eql(cur_wagon_size + 1)

      @train.unpin
      expect(@train.wagon_size).to eql(cur_wagon_size)
    end

    it 'принимать маршрут следования' do
      @train.route = @rt1
    end

    it 'при назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте' do
      expect(@train.route[:current].nil?).to eql(true)
      expect(@train.route[:routes_list].empty?).to eql(true)

      @train.route = @rt1
      expect(@train.route[:current].nil?).to eql(false)
      expect(@train.route[:routes_list].empty?).to eql(false)
    end

    it 'перемещаться между станциями, указанными в маршруте вперед на 1 станцию за раз' do
      @train.route = @rt1

      expect(@train.route[:previous].nil?).to eql(true)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      current_station = @train.route[:current]
      next_station = @train.route[:next]

      @train.forward

      expect(@train.route[:previous]).to eql(@st1)
      expect(@train.route[:current]).to eql(@st3)
      expect(@train.route[:next]).to eql(nil)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      @train.forward

      expect(@train.route[:previous]).to eql(@st1)
      expect(@train.route[:current]).to eql(@st3)
      expect(@train.route[:next]).to eql(nil)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])
    end

    it 'перемещаться между станциями, указанными в маршруте назад на 1 станцию за раз' do
      @train.route = @rt1

      @train.forward
      @train.forward

      expect(@train.route[:previous]).to eql(@st1)
      expect(@train.route[:current]).to eql(@st3)
      expect(@train.route[:next]).to eql(nil)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      @train.backward

      expect(@train.route[:previous]).to eql(nil)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])

      @train.backward

      expect(@train.route[:previous]).to eql(nil)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
      expect(@train.route[:routes_list]).to eql([@st1, @st3])
    end

    it 'возвращать предыдущую, текущую, следующую станцию на основе маршрута' do
      @train.route = @rt1

      expect(@train.route[:previous]).to eql(nil)
      expect(@train.route[:current]).to eql(@st1)
      expect(@train.route[:next]).to eql(@st3)
    end
  end
end
