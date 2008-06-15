module CachedModel
  module Expression
    class Truncate
      def initialize(arg1)
        @table_name = arg1.to_sym
      end
      
      attr_reader :table_name
      
      def table_name_as_string
        @table_name.to_s
      end
      
      def inspect
        "SQL Expression: Truncate table '#{table_name_as_string}'"
      end
      
      def call(collection)
        collection.clear
      end
    end
  end
end
