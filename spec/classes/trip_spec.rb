require './classes/trip'
require 'securerandom'
require 'timecop'

RSpec.describe Trip do
  before { Timecop.freeze }
  after { Timecop.return }

  let(:minutes) { 30 }
  let(:startTime) { (Time.now - (minutes * 60)).strftime('%H:%M') }
  let(:endTime) { Time.now.strftime('%H:%M') }
  let(:distance) { SecureRandom.random_number(100) }
  let(:trip) { Trip.new(startTime, endTime, distance) }

  describe '#initialize' do
    context 'when start time is after end time' do
      let(:trip) { Trip.new(endTime, startTime, distance) }
      it 'swaps the start and end times' do
        expect(trip.startTime.strftime('%H:%M')).to eq(startTime)
               expect(trip.endTime.strftime('%H:%M')).to eq(endTime)
      end
    end

    context 'when distance is negative' do
      let(:trip) { Trip.new(startTime, endTime, distance * -1) }
      it 'treats the distance as positive' do
        expect(trip.distance).to eq(distance)
      end
    end
  end

  describe '#time' do
    let(:minutes) { SecureRandom.random_number(61) }
    it 'returns trip time in hours' do
      expect(trip.time).to eq(minutes.to_f / 60)
    end
  end

  describe '#averageSpeed' do
    let(:time) { SecureRandom.random_number }

    before do
      allow(trip).to receive(:time).and_return(time)
    end

    it 'returns the average speed for the trip' do
      expect(trip.averageSpeed).to eq(distance / time)
    end
  end

  describe '#valid?' do
    let(:averageSpeed) { SecureRandom.random_number(96) + 5 }

    before do
      allow(trip).to receive(:averageSpeed).and_return(averageSpeed)
    end

    context 'when average speed is below 5mph' do
      let(:averageSpeed) { SecureRandom.random_number(5) }

      it 'returns false' do
        expect(trip.valid?).to be_falsy
      end
    end

    context 'when average speed is above 100mph' do
      let(:averageSpeed) { SecureRandom.random_number(100) + 100 }

      it 'returns false' do
        expect(trip.valid?).to be_falsy
      end
    end

    context 'when the average speed is in the acceptable limit' do
      it 'returns true' do
        expect(trip.valid?).to be_truthy
      end
    end
  end
end
