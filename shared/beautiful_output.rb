require 'benchmark'

def announce(message)
  length = [0, 75 - message.length].max
  puts "== %s %s" % [message, "=" * length]
end

def report(title, &block)
  announce(title)
  time = Benchmark.measure do
    yield block
  end
  announce "%.4fs" % time.real
  puts "\n"
end

def format_number(number)
  number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
end

def format_time(seconds)
  seconds = seconds.ceil
  hours = seconds / 3600
  mins = (seconds - 3600 * hours) / 60
  secs = seconds - 3600 * hours - 60 * mins
  "#{hours}h#{mins}m#{secs}s"
end
