require File.join(File.dirname(__FILE__), 'lib/craft_calculator')
require File.join(File.dirname(__FILE__), '../shared/beautiful_output')

AtlanticaOnline::CraftCalculator::Item.load_data_from_yaml

report "Print prices (calculated, fixed or assumed market prices) for all items" do
  AtlanticaOnline::CraftCalculator::Item.items.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{format_number(item.unit_price)}"
  end
end
