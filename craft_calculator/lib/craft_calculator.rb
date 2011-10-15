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

      def craft_xp_gained_per_batch
        workload / 50
      end

      def craft_xp_gained_per_item
        craft_xp_gained_per_batch / count.to_f
      end
    end

    class InvalidItem < RuntimeError
    end

    class Crafter
      def initialize(auto_craft_lvl)
        @auto_craft_lvl = auto_craft_lvl
      end

      def tick_workload
        100 + (@auto_craft_lvl - 1) * 20
      end

      def tick_count_for_workload(workload)
        (workload / tick_workload.to_f).ceil
      end

      def seconds_duration_for_workload(workload)
        (tick_count_for_workload(workload) * 5.35).ceil
      end

      def batches_per_hour(workload, hours = 1)
        (hours * 3600 / seconds_duration_for_workload(workload)).floor
      end

      def items_per_hour(workload, batch_size, hours = 1)
        batches_per_hour(workload, hours) * batch_size
      end
    end
  end
end
