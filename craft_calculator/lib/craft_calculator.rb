class CraftCalculator
  require 'yaml'
  attr_accessor :data

  def initialize(data_file = File.join(File.dirname(__FILE__), 'data.yml'))
    @data = YAML::load(File.open(data_file))
  end

  def unit_price(item_name, count = 1)
    item = load_item(item_name)

    if item["ingredients"]
      price = 0
      item["ingredients"].each do |ingredient_name, ingredient_count|
        price += unit_price(ingredient_name) * ingredient_count
      end
      if item["count"]
        price = price / item["count"]
      end
      if item["fixed_price"] && item["fixed_price"] < price
        price = item["fixed_price"]
      end
    else
      price = item["fixed_price"] || item["market_price"]
    end

    return price
  end

  def item_names
    data.keys
  end

  private

  def load_item(item_name)
    item = data[item_name]

    raise InvalidItem, "No item '#{item_name}' found" unless item

    return item
  end
end

class InvalidItem < RuntimeError
end

class GoldFormatter
  def self.format(number)
    number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end
end
