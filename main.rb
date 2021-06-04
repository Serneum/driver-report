require './classes/runner'

inputFile = ARGV[0]
runner = Runner.new(inputFile)
runner.processFile
runner.generateReport
