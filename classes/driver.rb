class Driver
  require './classes/trip'

  attr_reader :trips

  def initialize(name)
    @name = name
    @trips = []
  end

  def addTrip(startTime, endTime, distance)
    trip = Trip.new(startTime, endTime, distance)
    valid = trip.valid?
    @trips << trip if valid
    return valid
  end

  def totalMiles
    @trips.map(&:distance).reduce(0, :+)
  end

  def totalTime
    @trips.map(&:time).reduce(0, :+)
  end

  def averageSpeed
    return 0 if totalTime == 0
    totalMiles / totalTime
  end

  def report
    message = "#{@name}: #{totalMiles.round} miles"
    if totalMiles > 0
      message += " @ #{averageSpeed.round} mph"
    end
    message
  end
end
