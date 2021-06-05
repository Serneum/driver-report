require './classes/driver'
require 'securerandom'
require 'timecop'

RSpec.describe Driver do
  let(:name) { SecureRandom.alphanumeric }
  let(:driver) { Driver.new(name) }

  describe '#addTrip' do
    before { Timecop.freeze }
    after { Timecop.return }

    let(:startTime) { (Time.now - (30 * 60)).strftime('%H:%M') }
    let(:endTime) { Time.now.strftime('%H:%M') }
    let(:distance) { SecureRandom.random_number(100) }

    context 'when the trip is invalid' do
      before do
        allow_any_instance_of(Trip).to receive(:valid?).and_return false
      end

      it 'does not add the trip to the driver' do
        driver.addTrip(startTime, endTime, distance)
        expect(driver.trips).to be_empty
      end
    end

    context 'when the trip is valid' do
      before do
        allow_any_instance_of(Trip).to receive(:valid?).and_return true
      end

      it 'adds the trip to the driver' do
        driver.addTrip(startTime, endTime, distance)
        expect(driver.trips).to_not be_empty
      end
    end
  end

  describe '#totalMiles' do
    context 'when there are no trips' do
      it 'returns a total distance of 0' do
        expect(driver.totalMiles).to eq(0)
      end
    end

    context 'when there is a single trip' do
      let(:startTime) { (Time.now - (30 * 60)).strftime('%H:%M') }
      let(:endTime) { Time.now.strftime('%H:%M') }
      let(:distance) { SecureRandom.random_number(100) }

      before do
        allow_any_instance_of(Trip).to receive(:valid?).and_return true
        driver.addTrip(startTime, endTime, distance)
      end

      it 'returns the distance of the single trip' do
        expect(driver.totalMiles).to eq(distance)
      end

    end

    context 'when there are multiple trips' do
      before do
        allow_any_instance_of(Trip).to receive(:valid?).and_return true

        numTrips = SecureRandom.random_number(5)
        (0..numTrips).each do |_i|
          startTime = (Time.now - (SecureRandom.random_number(61) * 60)).strftime('%H:%M')
          endTime = (Time.now + (SecureRandom.random_number(61) * 60)).strftime('%H:%M')
          distance = SecureRandom.random_number(91) + 10
          driver.addTrip(startTime, endTime, distance)
        end
      end

      it 'returns a non-zero total distance' do
        expect(driver.totalMiles).to be > 0
      end

      it 'accurately calculates total distance traveled' do
        distance = driver.trips.map { |t| t.distance }.sum
        expect(driver.totalMiles).to eq(distance)
      end
    end
  end

  describe '#totalTime' do
    # TODO: This is pretty similar to totalMiles, so I am skipping implementing this for now
  end

  describe '#averageSpeed' do
    context 'when there are no trips' do
      it 'returns 0' do
        expect(driver.averageSpeed).to eq(0)
      end
    end

    context 'when there are trips' do
      let(:totalMiles) { SecureRandom.random_number(100) }
      let(:totalTime) { SecureRandom.random_number(111) + 10 }

      before do
        allow(driver).to receive(:totalMiles).and_return(totalMiles)
        allow(driver).to receive(:totalTime).and_return(totalTime)
      end

      it 'returns the average speed of the trips' do
        expect(driver.averageSpeed).to eq(totalMiles / totalTime)
      end
    end
  end

  describe '#report' do
    context 'when there are no trips' do
      it 'just returns a message about 0 miles traveled' do
        expect(driver.report).to eq("#{name}: 0 miles")
      end
    end

    context 'when there are trips' do
      let(:totalMiles) { SecureRandom.random_number(100) }
      let(:averageSpeed) { SecureRandom.random_number(40) }

      before do
        allow(driver).to receive(:totalMiles).and_return(totalMiles)
        allow(driver).to receive(:averageSpeed).and_return(averageSpeed)
      end

      it 'returns a message containing the average speed' do
        expect(driver.report).to eq("#{name}: #{totalMiles} miles @ #{averageSpeed} mph")
      end
    end
  end
end
