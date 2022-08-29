# frozen_string_literal: true

require 'rspec'

describe 'Route' do
  require 'faker'
  require_relative '../lib/route'
  require_relative '../lib/station'

  before do
    @st1 = Station.new(Faker::Lorem.word)
    @st2 = Station.new(Faker::Lorem.word)

    @st3 = Station.new(Faker::Lorem.word)
    @st4 = Station.new(Faker::Lorem.word)

    @rt1 = Route.new(@st1, @st2)
  end

  after do
    # Do nothing
  end

  context 'Имеет' do
    it 'начальную и конечную станцию' do
      expect(@rt1.routes.size).to eq(2)
      expect(@rt1.routes.first).not_to eq(nil)
      expect(@rt1.routes.last).not_to eq(nil)
    end
  end

  context 'Может' do
    it 'добавлять промежуточную станцию в список' do
      expect(@rt1.routes.size).to eq(2)

      @rt1.insert(@st3)
      expect(@rt1.routes).to eq([@st1, @st3, @st2])

      @rt1.insert(@st4)
      expect(@rt1.routes).to eq([@st1, @st3, @st4, @st2])
    end

    it 'удалять промежуточную станцию из списка' do
      expect(@rt1.routes.size).to eq(2)

      @rt1.insert(@st3)
      expect(@rt1.routes).to eq([@st1, @st3, @st2])

      @rt1.delete(@st3)
      expect(@rt1.routes).to eq([@st1, @st2])

      @rt1.delete(@st2)
      expect(@rt1.routes).to eq([@st1, @st2])
    end

    it 'выводить список всех станций по-порядку от начальной до конечной' do
      expect(@rt1.routes.inspect).to eq("[#{@st1.inspect}, #{@st2.inspect}]")
    end
  end
end
