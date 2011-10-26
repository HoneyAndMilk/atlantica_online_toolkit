require File.join(File.dirname(__FILE__), 'lib/craft_calculator')
require File.join(File.dirname(__FILE__), '../shared/beautiful_output')

AtlanticaOnline::CraftCalculator::Item.load_data_from_yaml

report "Print prices (calculated, fixed or assumed market prices) for all items" do
  AtlanticaOnline::CraftCalculator::Item.items.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{gold(item.unit_price)} (#{item.price_type})"
  end
end

report "Print money saved or lost by crafting for all craftable items available for fixed price" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? && i.direct_price }.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{gold(item.money_saved_by_crafting)}#{item.crafting_is_more_expensive? ? " MONEY LOST!": ""}"
  end
end

report "Print workload for all craftable items" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{workload(item.workload)}"
  end
end

report "Print skill and skill level for all craftable items" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{item.skill} #{item.skill_lvl}"
  end
end

report "Print craft XP gained for all craftable items" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{craft_xp(item.craft_xp_gained_per_batch)}/batch  #{craft_xp(item.craft_xp_gained_per_item)}/item"
  end
end

crafter_ac_1 = AtlanticaOnline::CraftCalculator::Crafter.new(1)
crafter_ac_120 = AtlanticaOnline::CraftCalculator::Crafter.new(120)

report "Print estimated craft times for all craftable items (for Auto-Craft lvl 1 and 120)" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{time(crafter_ac_1.seconds_duration_for_workload(item.workload))} / #{time(crafter_ac_120.seconds_duration_for_workload(item.workload))}"
  end
end

report "Print how many items can be crafted per hour for all craftable items (for Auto-Craft lvl 1 and 120)" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{crafter_ac_1.items_per_hour(item.workload, item.batch_size)} / #{crafter_ac_120.items_per_hour(item.workload, item.batch_size)}"
  end
end

report "Print how many items can be crafted per 8 hours for all craftable items (for Auto-Craft lvl 1 and 120)" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.craftable? }.sort_by { |i| i.name }.each do |item|
    puts "#{item(item.name)}: #{crafter_ac_1.items_per_hour(item.workload, item.batch_size, 8)} / #{crafter_ac_120.items_per_hour(item.workload, item.batch_size, 8)}"
  end
end

report "Print shopping list, craft list, total workload and total price" do
  AtlanticaOnline::CraftCalculator::Item.items.select{ |i| i.crafting_is_cheaper? }.sort_by { |i| i.name }.each do |item|
    count = 5
    craft_list, shopping_list, leftovers = item.craft(count)
    total_workload = craft_list.total_workload
    total_workload_per_skill = craft_list.total_workload_per_skill
    total_craft_xp_gained = craft_list.total_craft_xp_gained
    total_craft_xp_gained_per_skill = craft_list.total_craft_xp_gained_per_skill
    total_price = shopping_list.total_price
    puts "#{item(item.name)} (requested #{count}, crafted #{item.crafted_count(count)})"
    puts "  price: #{gold(total_price)}"
    puts "  workload: #{workload(total_workload)}"
    total_workload_per_skill.each do |skill, skill_workload|
      puts "    #{skill}: #{workload(skill_workload)}"
    end
    puts "  craft xp: #{craft_xp(total_craft_xp_gained)}"
    total_craft_xp_gained_per_skill.each do |skill, skill_craft_xp_gained|
      puts "    #{skill}: #{craft_xp(skill_craft_xp_gained)}"
    end
    puts "  craft time (Auto-Craft lvl 120): #{time(crafter_ac_120.seconds_duration_for_workload(total_workload))}"

    puts "buy:"
    shopping_list.each do |shopping_list_item|
      puts "  #{shopping_list_item.name}: #{shopping_list_item.count}"
    end

    puts "craft (in this order):"
    craft_list.each do |craft_list_item|
      puts "  #{craft_list_item.name}: #{craft_list_item.count}"
    end

    puts "leftovers:"
    leftovers.each do |leftover|
      puts "  #{leftover.name}: #{leftover.count}"
    end
  end
end
