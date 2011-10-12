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