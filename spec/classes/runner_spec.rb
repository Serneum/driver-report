require './classes/runner'
require 'securerandom'

RSpec.describe Runner do
  let(:runner) { Runner.new(inputFile) }

  describe '#processFile' do
    context 'when there is an invalid command in the input file' do
      let(:inputFile) { 'spec/fixtures/files/input-invalid.txt' }

      it 'raises an exception' do
        expect { runner.processFile }.to raise_error(/Invalid command/)
      end
    end

    context 'when there is a Driver command in the input file' do
      let(:inputFile) { 'spec/fixtures/files/input-driver.txt' }

      it 'calls processDriver' do
        expect(runner).to receive(:processDriver)
        runner.processFile
      end
    end

    context 'when there is a Trip command in the input file' do
      let(:inputFile) { 'spec/fixtures/files/input-trip.txt' }

      it 'calls processTrip' do
        expect(runner).to receive(:processTrip)
        runner.processFile
      end
    end
  end

  describe '#processDriver' do
    let(:inputFile) { 'spec/fixtures/files/input-driver.txt' }
    let(:name) { SecureRandom.alphanumeric }
    let(:lineParts) { [name] }

    context 'when a driver name is present' do
      it 'does not raise an error' do
        expect { runner.processDriver(lineParts) }.not_to raise_error
      end

      it 'creates a driver and stores it in a hash' do
        runner.processDriver(lineParts)
        expect(runner.getDriver(name)).not_to be_nil
      end
    end

    context 'when a driver name is not present' do
      let(:lineParts) { [] }

      it 'raises an error' do
        expect { runner.processDriver(lineParts) }.to raise_error(/A driver name is required/)
      end
    end
  end

  describe '#processTrip' do
    before { Timecop.freeze }
    after { Timecop.return }

    let(:inputFile) { 'spec/fixtures/files/input-trip.txt' }
    let(:name) { SecureRandom.alphanumeric }
    let(:minutes) { 30 }
    let(:startTime) { (Time.now - (minutes * 60)).strftime('%H:%M') }
    let(:endTime) { Time.now.strftime('%H:%M') }
    let(:distance) { SecureRandom.random_number(100).to_f }
    let(:lineParts) { [name, startTime, endTime, distance] }

    context 'when all required data is present' do
      before do
        runner.processDriver([name])
        allow_any_instance_of(Trip).to receive(:valid?).and_return true
      end

      it 'does not raise an error' do
        expect { runner.processTrip(lineParts) }.not_to raise_error
      end

      it 'creates a trip for the driver' do
        runner.processTrip(lineParts)
        expect(runner.getDriver(name).trips).not_to be_empty
      end
    end

    context 'when expected data is not present' do
      let(:lineParts) { [] }

      it 'raises an error' do
        expect { runner.processTrip(lineParts) }.to raise_error(/Expected driver, start time, end time, distance./)
      end
    end
  end
end
