module RedundantColumn
  module BelongsTo
    class CallbackBuilder
      attr_reader :name, :target_name, :association_name

      def initialize(name, target_name, association_name)
        @name = name
        @target_name =  target_name
        @association_name = association_name
      end

      def before_create(caller)
        if caller.read_attribute(name).nil?
          column_value = caller.send(association_name).try(target_name)
          caller.send("#{name}=", column_value)
          true
        end
      end
    end

    def self.included(base)
      base.valid_options += [:redundant_column]
    end

    def build
      reflection = super
      add_counter_cache_callbacks(reflection) if options[:counter_cache]
      add_touch_callbacks(reflection)         if options[:touch]
      configure_dependency
      configure_auto_fill_redundant_column_callback
      reflection
    end

    private

    def configure_auto_fill_redundant_column_callback
      if columns = options[:redundant_column]
        column = columns.to_a.first
        target_name = columns.to_a.last
        model.set_callback :create, :before, CallbackBuilder.new(column, target_name, self.name)
      end
    end
  end
end
ActiveRecord::Associations::Builder::BelongsTo.send(:include, RedundantColumn::BelongsTo)