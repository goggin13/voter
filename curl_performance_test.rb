require "json"
num_threads = ARGV.length > 0 ? ARGV[0].to_i : 1
num_requests = 10

command = "curl -s 'https://agile-ridge-67293.herokuapp.com/lists/746.json?session_id=nmyi4e'"

puts "running with #{num_threads} threads"
threads = (1..num_threads).map do |i|
  Thread.new do
    total_duration = 0
    num_requests.times do
      start_time = Time.now
      `#{command}`
      duration = Time.now - start_time
      if $?.exitstatus == 0
        total_duration += duration
        print "."
      else
        puts "#{i}: failed in #{duration} seconds"
      end
    end

    sleep 0.2 * i
    puts "#{i}: #{num_requests}, avg=#{total_duration/num_requests.to_f} seconds"
  end
end

threads.map(&:join)
puts
