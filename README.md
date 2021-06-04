# driver-report

This program is a little over-engineered, but the prompt requested multiple classes and I wanted to make sure that requirement was satisfied. Looking forward, if this were to become a real project I would:
1. Add a persistent data store
2. Find some way to uniquely identify Trips, and guarantee they are only stored once
3. Likely do something like batch the inputs from a file, and remove the input file if the full batch was imported. Otherwise, discard the imported data
4. Raising errors is not the best method of reporting issues to the user. I'd like to process all lines in a file and then report all of the errors at once. This makes for easier debugging because a user could address all of the issues in a file before trying again instead of fixing one error, running the program, fixing the next error, etc.
5. Spin up a web server. Allow the user to perform CRUD operations on Drivers and Trips to fix any data that may have been valid, but incorrect and also avoid the need for input files

---

### main.rb

This class solely exists as an entrypoint into the system. It takes in he user input, creates an instance of the `Runner` class, processes the data, and prints out the report. There are no real decisions or choices here.

### runner.rb

I could have put all of the logic into the `processFile` method, or even just in the initializer, but I wanted to break things up into easily testable chunks.

I have two methods: `processDriver` and `processTrip`. Realistically, I could have used some metaprogramming to dynamically create those methods and any others that might have been added later, but I find that metaprogramming can often make programs difficult to debug because it can be hard to find the code that actually generates or calls the methods.

I opted for raising errors around invalid input even though the prompt made it clear that data would have a specific format. This was mostly because you can never really trust input from an external source, and I wanted to be a little pessimistic in the file processing.

### driver.rb

This is a pretty basic class, with no real big choices. I opted to have a `report` method so that a user could opt for individual driver reports, or a full report of all drivers like the `generateReport` method in `runner.rb`. This also makes the output easy to test and validate.

For the `averageSpeed` calculation, I opted for an early return if the driver had never recorded a trip. This prevents an error around dividing by 0. There is no need to do the same check for `totalMiles` because dividing `0` by any non-zero amount of time would still be `0`.

If this project were to continue, trips would be a model association via ActiveRecord, but this was a rapid prototype so it is just a list of objects for now.

### trip.rb

Much like in `runner.rb`, I opted to be pessimistic about input and add start/end time swapping if the end time is actually before the start time. While the prompt specified that the end time would always be a later time, you can never fully trust external input.

The trip time also handles converting down to hours as that is the common unit of time that makes all other calculations elsehwere easier.
