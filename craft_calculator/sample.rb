require File.join(File.dirname(__FILE__), 'lib/craft_calculator')
require File.join(File.dirname(__FILE__), '../shared/beautiful_output')

AtlanticaOnline::CraftCalculator::Item.load_data_from_yaml

report "Print prices (calculated, fixed or assumed market prices) for all items" do
  AtlanticaOnline::CraftCalculator::Item.items.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{format_number(item.unit_price)}"
  end
end

report "Print workload for all craftable items" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{format_number(item.workload)}"
  end
end

report "Print skill and skill level for all craftable items" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{item.skill} #{item.skill_lvl}"
  end
end

report "Print craft XP gained for all craftable items" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{item.craft_xp_gained_per_batch}/batch  #{item.craft_xp_gained_per_item}/item"
  end
end

crafter_ac_1 = AtlanticaOnline::CraftCalculator::Crafter.new(1)
crafter_ac_120 = AtlanticaOnline::CraftCalculator::Crafter.new(120)

report "Print estimated craft times for all craftable items (for Auto-Craft lvl 1 and 120)" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{format_time(crafter_ac_1.seconds_duration_for_workload(item.workload))} / #{format_time(crafter_ac_120.seconds_duration_for_workload(item.workload))}"
  end
end

report "Print how many items can be crafted per hour for all craftable items (for Auto-Craft lvl 1 and 120)" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{crafter_ac_1.items_per_hour(item.workload, item.count)} / #{crafter_ac_120.items_per_hour(item.workload, item.count)}"
  end
end

report "Print how many items can be crafted per 8 hours for all craftable items (for Auto-Craft lvl 1 and 120)" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item.name}: #{crafter_ac_1.items_per_hour(item.workload, item.count, 8)} / #{crafter_ac_120.items_per_hour(item.workload, item.count, 8)}"
  end
end
