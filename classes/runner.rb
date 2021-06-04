class Runner
  require './classes/driver'
  require './classes/trip'

  VALID_COMMANDS = [
    'Driver',
    'Trip'
  ].freeze

  def initialize(inputFile)
    @inputFile = inputFile
    @driverData = {}
  end

  def getDriver(name)
    @driverData.dig(name.to_sym)
  end

  def processFile
    input = File.open(@inputFile).read
    input.each_line do |line|
      lineParts = line.split(/\s+/)
      command = lineParts.shift
      case command
      when 'Driver'
        processDriver(lineParts)
      when 'Trip'
        processTrip(lineParts)
      else
        raise "Invalid command: '#{command}'. Valid commands: #{VALID_COMMANDS.to_s}"
      end
    end
  end

  def processDriver(lineParts)
    name = lineParts.shift
    raise "A driver name is required after the Driver command." unless name
    driver = getDriver(name)
    @driverData[name.to_sym] = Driver.new(name) unless driver
  end

  def processTrip(lineParts)
    raise "Invalid data set: #{lineParts.to_s}. Expected driver, start time, end time, distance." unless lineParts.size == 4
    name = lineParts.shift
    driver = getDriver(name)
    raise "Driver '#{name}' does not already exist in the system." unless driver
    startTime = lineParts.shift
    endTime = lineParts.shift
    distance = lineParts.shift
    trip = Trip.new(startTime, endTime, distance)
    driver.trips << trip if trip.valid?
  end

  def generateReport
    sortedDrivers = @driverData.map { |k, v| v }.sort_by(&:totalMiles).reverse
    sortedDrivers.each { |d| puts d.report }
  end
end
