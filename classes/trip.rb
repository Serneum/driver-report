class Trip
  require 'time'

  attr_reader :startTime, :endTime, :distance

  def initialize(startTime, endTime, distance)
    @startTime = Time.parse(startTime)
    @endTime = Time.parse(endTime)
    unless @startTime < @endTime
      tmpTime = @startTime
      @startTime = @endTime
      @endTime = tmpTime
    end

    @distance = distance.to_f.abs
  end

  def time
    (@endTime - @startTime) / 60 / 60
  end

  def averageSpeed
    @distance / time
  end

  def valid?
    avg = averageSpeed
    avg >= 5 && avg <= 100
  end
end
