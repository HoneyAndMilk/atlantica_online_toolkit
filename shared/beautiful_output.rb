require 'benchmark'

begin
  require 'ansi/code'
rescue LoadError
  begin
    require 'rubygems'
    require 'ansi/code'
  rescue LoadError
    puts 'WARNING: You have to "gem install ansi" to get colored output'
  end
end

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
  number = number.to_i if (number % 1).zero?
  parts = number.to_s.to_str.split('.')
  parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, '\\1,')
  parts.join('.')
end

def format_time(seconds)
  seconds = seconds.ceil
  hours = seconds / 3600
  mins = (seconds - 3600 * hours) / 60
  secs = seconds - 3600 * hours - 60 * mins
  "#{hours}h#{mins}m#{secs}s"
end

def print_item_with_raw_craft_tree(item, level = 0)
  puts "#{" " * (level * 2)} #{item.name} - required: #{item.count}, crafted/purchased: #{item.crafted_count}, price type: #{item.price_type}"
  item.ingredients_craft_tree.each do |i|
    print_item_with_raw_craft_tree(i, level + 1)
  end
end

def colorize?
  defined?(::ANSI::Code)
end

def item(string)
  colorize? ? ::ANSI::Code.green { string } : string
end

def gold(fixnum)
  string = format_number(fixnum)
  colorize? ? ::ANSI::Code.yellow { string } : string
end

def workload(fixnum)
  string = format_number(fixnum)
  colorize? ? ::ANSI::Code.cyan { string } : string
end

def craft_xp(number)
  string = format_number(number)
  colorize? ? ::ANSI::Code.red { string } : string
end

def time(seconds)
  string = format_time(seconds)
  colorize? ? ::ANSI::Code.magenta { string } : string
end
