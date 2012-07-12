module RedundantColumn
  module HasMany
    class CallbackBuilder
      attr_reader :name, :target_name, :association_name

      def initialize(name, target_name, association_name)
        @name = name
        @target_name =  target_name
        @association_name = association_name
      end

      def before_update(caller)
        if caller.send("#{name}_changed?")
          if caller.respond_to?(association_name)
            new_column_value = caller.send(name)

            update_sql =  if new_column_value.is_a?(String)
              %Q|#{target_name} = '#{new_column_value.gsub("'", "\\'")}'|
            else
              %Q|#{target_name} = #{new_column_value}|
            end
            caller.send(association_name).update_all(update_sql)
          else
            STDERR.puts "You must set association in #{caller.class} model:"
            STDERR.puts "has_many :#{association_name}, ..."
          end
        end
      end
    end


    def self.included(base)
      base.valid_options += [:redundant_column]
    end

    def build
      reflection = super
      configure_dependency
      configure_update_redundant_column_callback
      reflection
    end

    private

    def configure_update_redundant_column_callback
      if columns = options[:redundant_column]
        if columns.is_a?(Array)
          columns.each do |column|
            model.set_callback :update, :before, CallbackBuilder.new(column, model.name.downcase + "_#{column}", self.name)
          end
        elsif columns.is_a?(Hash)
          columns.each do |column, target_name|
            model.set_callback :update, :before, CallbackBuilder.new(column, target_name, self.name)
          end
        else
          model.set_callback :update, :before, CallbackBuilder.new(column, model.name.downcase + "_#{columns}", self.name)
        end
      end
    end
  end
end
ActiveRecord::Associations::Builder::HasMany.send(:include, RedundantColumn::HasMany)