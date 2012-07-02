require "redundant_column/version"

module RedundantColumn
  def redundant_column(name, target_model, options = {}) 
    set_callback :update, :before, CallbackBuilder.new(name, target_model, options)
  end

  class CallbackBuilder
    attr_reader :name, :target_model, :target_name, :association_name

    def initialize(name, target_model, options = {})
      @name = name
      @target_model = target_model
      @target_name =  options[:target_name] 
      @association_name = options[:association_name] || "#{target_model.name.downcase.pluralize}"
    end

    def before_update(caller) 
      if caller.send("#{name}_changed?")
        if caller.respond_to?(association_name)
          new_column_value = caller.send(name)
          target_name ||= "#{caller.class.name.downcase}_#{name}"
          update_sql = new_column_value.is_a?(String) ? %Q|#{target_name} = '#{new_column_value.gsub("'", "\\'")}'| : %Q|#{target_name} = #{new_column_value}|
          caller.send(association_name).update_all(update_sql)
        else
          STDERR.puts "You must set association in #{caller.class} model:"
          STDERR.puts "has_many :#{association_name}, ..."
        end
      end
    end
  end
end

ActiveRecord::Base.send :extend, RedundantColumn
