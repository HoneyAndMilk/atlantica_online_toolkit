module AtlanticaOnline
  module CraftCalculator
    class Item
      def self.load_data_from_yaml(data_file = File.join(File.dirname(__FILE__), 'data.yml'))
        require 'yaml'

        yaml_data = YAML::load(File.open(data_file))

        self.all = yaml_data
      end

      def self.all=(hash)
        @@all = {}

        hash.each do |item_name, item_data|
          @@all[item_name] = new(item_data.merge({ "name" => item_name}))
        end
      end

      def self.all
        @@all || {}
      end

      def self.find(item_name)
        item = all[item_name]

        raise InvalidItem, "No item '#{item_name}' found" unless item

        return item
      end

      def self.items
        all.values
      end

      def initialize(hash)
        @data = hash
      end

      [
        :name,
        :ingredients,
        :workload,
        :skill,
        :skill_lvl,
        :market_price,
        :fixed_price,
      ].each do |method_name|
        define_method method_name do
          @data[method_name.to_s]
        end
      end

      def count
        @data["count"] || 1
      end

      def craftable?
        !ingredients.nil?
      end

      def direct_price
        fixed_price || market_price
      end

      def unit_price
        if craftable?
          result = 0
          ingredients.each do |ingredient_name, ingredient_count|
            result += self.class.find(ingredient_name).unit_price * ingredient_count
          end
          result = result / count
          if direct_price && direct_price < result
            result = direct_price
          end
        else
          result = direct_price
        end

        return result
      end
    end

    class InvalidItem < RuntimeError
    end
  end
end
