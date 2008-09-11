module Guillotine
  module Expressions
    class Truncate
      def initialize(arg1)
        @table_name = arg1.to_sym
      end
      
      attr_reader :table_name
      
      def inspect
        "SQL Expression: #{to_sql}"
      end
      
      def call(collection)
        collection.clear
      end
      
      def ==(other)
        self.table_name == other.table_name
      end
      
      def to_sql
        "TRUNCATE TABLE `#{@table_name}`"
      end
    end
  end
end
