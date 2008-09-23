module Guillotine
  module Expressions
    class Insert
      class UnknownInsertExpression < StandardError; end
      
      def initialize(options={ })
        set_each_option(options)
      end
      
      attr_accessor :into
      attr_accessor :columns
      attr_accessor :values
      
      alias_method :table_name, :into
      
      def to_sql
        s =  "INSERT INTO #{table_name}"
        if columns
          s += " (#{transform_to_sql(columns)})"
        end
        s += " VALUES (#{values_as_sql})"
      end
      
    private
      
      def values_as_sql
        transform_to_sql(values) { |v| value_to_sql(v) }
      end
      
      def transform_to_sql(collection, &blk)
        results = block_given? ? collection.map(&blk) : collection
        results.join(", ")
      end
      
      def value_to_sql(value)
        if value.kind_of?(String)
          "\"#{value}\""
        else
          value
        end
      end
      
      def set_each_option(options)
        options.each do |key, value|
          writer = "#{key}=".to_sym
          
          if respond_to?(writer)
            __send__(writer, value)
          else
            raise UnknownInsertExpression, "#{key} is not a valid insert key"
          end
        end
      end
    end
  end
end
