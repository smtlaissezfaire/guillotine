module Guillotine
  module Expressions
    class Column
      def initialize(table_name, column_name)
        @table_name = table_name
        @column_name = column_name
      end
      
      attr_reader :table_name
      attr_reader :column_name
      
      def to_sql
        "#{table_name}.#{column_name}"
      end
    end
  end
end
