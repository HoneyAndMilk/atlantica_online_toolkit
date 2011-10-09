require File.join(File.dirname(__FILE__), 'lib/craft_calculator')
require File.join(File.dirname(__FILE__), '../shared/beautiful_output')

calculator = CraftCalculator.new

report "Print prices (calculated, fixed or assumed market prices) for all items" do
  calculator.item_names.sort.each do |item_name|
    puts "#{item_name}: #{GoldFormatter.format(calculator.unit_price(item_name))}"
  end
end
